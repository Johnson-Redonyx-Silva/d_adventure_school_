import 'package:flutter/material.dart';

class TaskDetailsPage extends StatelessWidget {
  final Map<String, dynamic> taskDetails;

  const TaskDetailsPage({Key? key, required this.taskDetails}) : super(key: key);

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
              child: Text(taskDetails['username'],style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Task",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )
                ),
                Container(
                  width: double.infinity,
                  // height: 38,
                  decoration:     BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0x0c7d7d7d)),
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(taskDetails['taskName']),
                      ],
                    ),
                  ),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Task Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )
                ),
                Container(
                    width: double.infinity,
                    // height: 38,
                    decoration:     BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0x0c7d7d7d)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(taskDetails['task_des']),
                    )),
              ],
            ),

            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}