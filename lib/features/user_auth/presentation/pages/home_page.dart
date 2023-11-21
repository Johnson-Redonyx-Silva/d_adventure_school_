import 'package:d_adventure_school/features/user_auth/presentation/pages/add_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:d_adventure_school/global/common/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final User user;
  final data;

  const HomePage({super.key, required this.user, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String role = '';
  @override
  void initState() {
    super.initState();
    getUserdata();
  }

  getUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? 'No role';
    });
    print(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('$role console'),
        actions: [
          role == 'teacher'
              ? IconButton(
                  onPressed: () async {
                    // await getUsers();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTasks()));
                  },
                  icon: const Icon(Icons.add))
              : const SizedBox(),
          IconButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear(); // This clears all data in SharedPreferences
                showToast(message: "Successfully signed out");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView(
            children: List.generate(
              10,
              (index) => ElevatedButton(
                onPressed: () {
                  // Add your onPressed logic here
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5, // Adjust the elevation as needed
                ),
                child: ListTile(
                  title: Text('Item $index'),
                  subtitle: Text('Subtitle $index'),
                  leading: Icon(Icons.star), // Replace with your desired icon
                  trailing: Icon(
                      Icons.arrow_forward), // Replace with your desired icon
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
