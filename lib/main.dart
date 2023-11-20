import 'package:d_adventure_school/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:d_adventure_school/features/user_auth/presentation/pages/home_page.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/login_page.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/sign_up_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDBYLZ1vtGihJu41uHrny2uBnz2vyvzjU4",
          appId: "1:418267352029:web:7ba23dcaa8e07da8538434",
          messagingSenderId: "418267352029",
          projectId: "d-adventure-school-auth"
      ),
    );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => HomePage(user: FirebaseAuth.instance.currentUser!,data: FirebaseAuth.instance.currentUser!,),
      },
    );
  }
}
