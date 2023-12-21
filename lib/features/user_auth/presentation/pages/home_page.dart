import 'package:flutter/material.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/add_tasks.dart';
import 'package:d_adventure_school/features/user_auth/presentation/pages/task_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User user;
  final data;

  const HomePage({Key? key, required this.user, required this.data})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String role = '';
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];
  TextEditingController searchController = TextEditingController();
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    getTasksForUser();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    var username = prefs.getString('username');
    print('username @@@ => $username');
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> getTasksForUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? 'No role';
    });
    print("role--->$role");
    String userId = widget.user.uid;

    try {
      QuerySnapshot tasksSnapshot;

      if (role == 'student') {
        tasksSnapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: userId)
            .get();
      } else if (role == 'teacher') {
        tasksSnapshot =
            await FirebaseFirestore.instance.collection('tasks').get();
      } else {
        // Handle other roles or unexpected scenarios
        return;
      }

      List<Map<String, dynamic>> userTasks = [];
      tasksSnapshot.docs.forEach((doc) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          userTasks.add(data);
        }
      });

      // Sort the userTasks based on the createdAt field in descending order
      userTasks.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

      setState(() {
        tasks = userTasks;
        filteredTasks = tasks;
      });
    } catch (e) {
      print('Error getting tasks: $e');
    }
  }

  getUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? 'No role';
    });
    print("role--->$role");
  }

  Future<void> addTask(Map<String, dynamic> taskData, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(userId)
          .collection('userTasks')
          .add(taskData);
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  void addTaskToList(Map<String, dynamic> task) {
    String userId = widget.user.uid;
    addTask(task, userId);

    setState(() {
      tasks.add(task);
      filteredTasks = tasks;
    });
  }

  void searchTasks(String query) {
    List<Map<String, dynamic>> matchingTasks = tasks.where((task) {
      return task['username'].toLowerCase().contains(query.toLowerCase()) ||
          task['taskName'].toLowerCase().contains(query.toLowerCase()) ||
          task['task_des'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTasks = matchingTasks;
    });
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTasks(
                          onTaskAdded: addTaskToList,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isRefreshing = true;
          });
          await getTasksForUser();
          setState(() {
            isRefreshing = false;
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  searchTasks(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isRefreshing
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount:
                          filteredTasks.isEmpty ? 1 : filteredTasks.length,
                      itemBuilder: (context, index) {
                        if (filteredTasks.isEmpty) {
                          return Center(
                            child: Text(
                              'No matching tasks found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else {
                          final task = filteredTasks[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                task['username'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Task: ${task['taskName']}\nTask Description: ${task['task_des']}',
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsPage(
                                      taskDetails: task,
                                    ),
                                  ),
                                );
                              },
                              tileColor: const Color(0x0C01A674),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
