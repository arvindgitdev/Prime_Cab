import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:PrimeServices/firebase_options.dart';
import 'package:PrimeServices/provider/auth_provider.dart';
import 'package:PrimeServices/splash_screen.dart';
import 'package:PrimeServices/Consumer/login_screen.dart';
import 'package:PrimeServices/Driver/driver_login.dart';
import 'package:PrimeServices/food_vendor/login.dart';
import 'package:PrimeServices/login_page.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'utility/utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  platformSpecificInit();

  runApp(const MyApp());
}

void platformSpecificInit() {
  if (Platform.isIOS) {
    // iOS-specific initialization
  } else if (Platform.isAndroid) {
    // Android-specific initialization
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          SizeConfig.init(context);
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Prime Cab',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                ),
                home: const SplashScreen(),
                routes: {
                  '/login': (context) => const LoginPage(),
                  '/driver': (context) => const DLoginPage(),
                  '/consumer': (context) => const MyPhone(),
                  '/vendor': (context) => const Vlogin(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
