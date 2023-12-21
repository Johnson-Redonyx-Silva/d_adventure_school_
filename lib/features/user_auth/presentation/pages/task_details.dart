import 'package:d_adventure_school/features/user_auth/presentation/pages/edit_task.dart';
import 'package:d_adventure_school/utils/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetailsPage extends StatefulWidget {
  final Map<String, dynamic> taskDetails;

  const TaskDetailsPage({Key? key, required this.taskDetails})
      : super(key: key);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  bool isCompleted = false;
  String role = '';
  @override
  void initState() {
    super.initState();
    taskStatus();
    getRole();
  }

  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.role = prefs.getString('role') ?? 'No role';
    });
    // print('this.role from edit: ${this.role}');
  }

  taskStatus() {
    // print('object: ${widget.taskDetails['completed']}');
    setState(() {
      widget.taskDetails['completed'] == 'yes'
          ? this.isCompleted = true
          : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.taskDetails['username'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                Container(
                  width: double.infinity,
                  // height: 38,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0x0c7d7d7d)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(widget.taskDetails['taskName']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                Container(
                    width: double.infinity,
                    // height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0x0c7d7d7d)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.taskDetails['task_des']),
                    )),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Assigned By :'),
                Text(
                  widget.taskDetails['assignedBy'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Home'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var res = await markAsCompled(widget.taskDetails['taskId']);
                    print(res);
                    if (res == 'marked as completed') {
                      setState(() {
                        isCompleted = true;
                      });
                      print(isCompleted);
                    }
                  },
                  child: isCompleted
                      ? const Text('Completed')
                      : const Text('Mark as completed'),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            role == 'teacher'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditTask(taskDetails: widget.taskDetails),
                            ),
                          );
                        },
                        child: const Text('Edit task'),
                      ),
                    ],
                  )
                : Padding(padding: EdgeInsets.all(0)),
          ],
        ),
      ),
    );
  }
}
