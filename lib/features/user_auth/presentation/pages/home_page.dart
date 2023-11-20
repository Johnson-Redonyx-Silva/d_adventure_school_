import 'package:d_adventure_school/features/user_auth/presentation/pages/add_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:d_adventure_school/global/common/toast.dart';

import '../../../../global/common/toast.dart';
import '../../../../utils/firebase_service.dart';

class HomePage extends StatefulWidget {
  final User user;
  final data;

  const HomePage({super.key, required this.user, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("HomePage"),
        actions: [
          IconButton(
              onPressed: ()async {
                // await getUsers();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTasks()));
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
                showToast(message: "Successfully signed out");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${widget.user.email}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Text(
              widget.data['role'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            if (widget.data['role'] == 'teacher')
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'only for teacher',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              const Padding(padding: EdgeInsets.all(0)),
          ],
        ),
      ),
    );
  }
}
