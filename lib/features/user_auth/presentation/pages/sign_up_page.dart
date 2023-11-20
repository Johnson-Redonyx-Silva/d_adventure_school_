import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_adventure_school/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/login_page.dart';
import 'package:d_adventure_school/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:d_adventure_school/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _roleController = TextEditingController();

  bool _obscureText = true;
  bool isSigningUp = false;
  int? _selectedRole;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          controller:_usernameController,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        )
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _selectedRole,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRole =
                              _selectedRole == value ? null : value;
                              _roleController.text =
                              _selectedRole == 1 ? 'teacher' : '';
                            });
                          },
                        ),
                        const Text("Don't click if you are a Student")
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff01a674),
                        // Set the button's background color.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10),
                        ),
                        minimumSize: const Size(
                            330, 52),
                      ),
                      onPressed:_signUp,
                      child: const Text("Sign Up",
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
                        const Text("Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text("Login",
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
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);


  if(user!.uid !=null){
    print('user: ${user!.uid}');
    await storeUser(username,_roleController.text,user!.uid,);
  }
    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }
}
Future<void> storeUser(username, String role,String uid) async {
  // var uid= const Uuid().v1();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection = firestore.collection('users');
  final DocumentReference userDocument = usersCollection.doc(uid);
  await userDocument.set({
    'uid': uid,
    'role': role==''?'student':role,
    'username': username,
  });

}