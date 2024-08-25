import 'package:PrimeServices/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  User? _user;

  AuthProvider({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    // Listen to authentication state changes
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners(); // Notify listeners whenever the user state changes
  }

  // Phone Authentication
  Future<void> verifyPhoneNumber(
      String phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<User?> signInWithPhoneNumber(String verificationId, String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final UserCredential userCredential =
    await _firebaseAuth.signInWithCredential(credential);
    _user = userCredential.user;
    notifyListeners();
    return _user;
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
    await _firebaseAuth.signInWithCredential(credential);
    _user = userCredential.user;
    notifyListeners();
    return _user;
  }

  // Apple Sign-In (iOS only)
  Future<User?> signInWithApple() async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (result.status == AuthorizationStatus.authorized) {
      final appleIdCredential = result.credential!;
      final oAuthProvider = OAuthProvider('apple.com');

      final AuthCredential credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(appleIdCredential.identityToken!),
        accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
      );

      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();
      return _user;
    } else {
      return null;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType'); // Clear the user type from SharedPreferences

    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
