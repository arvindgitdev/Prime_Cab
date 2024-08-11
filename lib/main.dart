import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:primecabs/firebase_options.dart';
import 'package:primecabs/splash_screen.dart';
import 'package:primecabs/utility/utility.dart';
import 'dart:io';  // Import for platform-specific code

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  platformSpecificInit();  // Optional platform-specific initialization

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
    return LayoutBuilder(  // Use LayoutBuilder to get the constraints
      builder: (context, constraints) {
        SizeConfig.init(context);  // Initialize SizeConfig
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prime Cab',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
