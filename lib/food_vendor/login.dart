import 'package:flutter/material.dart';
import 'package:primecabs/food_vendor/v_nav.dart';
import 'package:primecabs/food_vendor/ven_detail.dart';
import 'package:primecabs/provider/auth_provider.dart' as customAuthProvider;
import 'package:firebase_auth/firebase_auth.dart';

class Vlogin extends StatefulWidget {
  const Vlogin({super.key});

  @override
  State<Vlogin> createState() => _VloginState();
}

class _VloginState extends State<Vlogin> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();
  String? verificationId;
  bool isCodeSent = false;

  @override
  void initState() {
    countryController.text = "+91"; // Default country code
    super.initState();
  }

  Future<void> _verifyPhoneNumber() async {
    final authProvider = customAuthProvider.AuthProvider();

    await authProvider.verifyPhoneNumber(
      '${countryController.text}${phoneController.text}',
          (PhoneAuthCredential credential) async {
        // Auto-complete feature, sign in the user
        User? user = await authProvider.signInWithPhoneNumber(verificationId!, credential.smsCode!);
        _handleSignIn(user);
      },
          (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${e.message}')));
      },
          (String verificationId, [int? resendToken]) {
        setState(() {
          this.verificationId = verificationId;
          isCodeSent = true;
        });
      },
          (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithCode() async {
    final authProvider = customAuthProvider.AuthProvider();
    if (verificationId != null && smsCodeController.text.isNotEmpty) {
      try {
        User? user = await authProvider.signInWithPhoneNumber(verificationId!, smsCodeController.text);
        _handleSignIn(user);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${e.toString()}')));
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final authProvider = customAuthProvider.AuthProvider();
    final user = await authProvider.signInWithGoogle();
    _handleSignIn(user);
  }

  Future<void> _signInWithApple() async {
    final authProvider = customAuthProvider.AuthProvider();
    final user = await authProvider.signInWithApple();
    _handleSignIn(user);
  }

  Future<void> _handleSignIn(User? user) async {
    if (user != null) {
      // Check if the user is new
      bool isNewUser = user.metadata.creationTime == user.metadata.lastSignInTime;
      if (isNewUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VenInfoPage(user: user)),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const VendorHome()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(60),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Welcome to PrimeServices",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!isCodeSent)
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _verifyPhoneNumber,
                    child: const Text("Continue"),
                  ),
                ),
              if (isCodeSent)
                Column(
                  children: [
                    TextField(
                      controller: smsCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter SMS code",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _signInWithCode,
                        child: const Text("Sign In"),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('-------', style: TextStyle(color: Colors.black, fontSize: 25)),
                    Text('or Login with', style: TextStyle(color: Colors.black)),
                    Text('-------', style: TextStyle(color: Colors.black, fontSize: 25)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _signInWithGoogle,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.g_mobiledata, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: _signInWithApple,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.apple, color: Colors.white, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
