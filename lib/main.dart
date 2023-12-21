import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:shared_preferences/shared_preferences.dart';

import 'package:d_adventure_school/features/app/splash_screen/splash_screen.dart';
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
        projectId: "d-adventure-school-auth"),
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
      title: 'd-adventure-school',
      home: FutureBuilder(
        // Check the login status before building the main app
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the user is logged in, navigate to the home page
            if (snapshot.data == true) {
              return HomePage(
                user: FirebaseAuth.instance.currentUser!,
                data: FirebaseAuth.instance.currentUser!,
              );
              // return Dashboard();
            } else {
              // If the user is not logged in, navigate to the login page
              return SplashScreen(
                child: LoginPage(),
              );
            }
          } else {
            // Display a loading indicator while checking the login status
            return CircularProgressIndicator();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Return the login status to determine the initial route
    return isLoggedIn;
  }
}
