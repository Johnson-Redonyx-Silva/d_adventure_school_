import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/forgot_password.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:d_adventure_school/global/common/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  bool _obscureText = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset("assets/tent 1.png"),
                    const Text("D Adventure School",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const Text("Welcome!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    )),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("User ID",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              controller: _emailController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Password",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()));
                            },
                            child: const Text("Forgot Password?",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff01a674),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(330, 52),
                        ),
                        onPressed: () {
                          _signIn();
                        },
                        child: const Text("Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ))),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    // print('user :${user!.uid}');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference usersCollection = firestore.collection('users');
    final DocumentReference userDocument = usersCollection.doc(user!.uid);
    // Retrieve user data from Firestore
    DocumentSnapshot userSnapshot = await userDocument.get();
    // print('UID: ${userSnapshot['uid']}');
    // print('Role: ${userSnapshot['role']}');
    // print('email: ${userSnapshot['username']}');

    setState(() {
      _isSigning = false;
    });
    showToast(message: "User is successfully signed in");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', userSnapshot['role']);
    prefs.setString('username', userSnapshot['username']);
    prefs.setString('uid', userSnapshot['uid']);
    prefs.setBool('isLoggedIn', true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: user, data: userSnapshot),
      ),
    );
  }
}
