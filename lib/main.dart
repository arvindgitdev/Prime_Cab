import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:primecabs/firebase_options.dart';

import 'package:primecabs/splash_screen.dart';
import 'package:primecabs/utility/utility.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
          home:SplashScreen(),
        );
      },
    );
  }
}
