import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/firebase_service.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  List<Map<String, dynamic>> userDataTemp = [];

  String selectedUsername = '';
  String selectedUid = '';
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  void dispose() {
    super.dispose();
    _taskNameController.dispose();
    _taskDescController.dispose();
  }

  getUser() async {
    userDataTemp = await getUsers();
    print('userDataTemp : $userDataTemp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 100, child: const Text("Username")),
              Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: userDataTemp.length,
                            itemBuilder: (context, index) {
                              final user = userDataTemp[index];
                              return ListTile(
                                title: Text(user['username']),
                                trailing: (selectedUid == user['uid'])
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () {
                                  setState(() {
                                    selectedUsername = user['username'];
                                    selectedUid = user['uid'];
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    (selectedUsername.isNotEmpty)
                        ? selectedUsername
                        : "Select Username",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
          // DropdownButton<String>(
          //   value: selectedUsername,
          //   hint: Text('Select a username'),
          //   onChanged: (String? newValue) {
          //     print('object');
          //     setState(() {
          //       selectedUsername = newValue!;
          //       selectedUid = userDataTemp.firstWhere((user) => user['username'] == newValue)['uid'];
          //     });
          //   },
          //   items: userDataTemp.map((user) {
          //     return DropdownMenuItem<String>(
          //       value: user['username'],
          //       child: Text(user['username']),
          //     );
          //   }).toList(),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 100, child: const Text("Task")),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 100, child: const Text("Task Description")),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: _taskDescController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () async {
              var taskData = {
                'uid': selectedUid,
                'username': selectedUsername,
                'taskName': _taskNameController.text,
                'task_des': _taskDescController.text,
              };
              var res= await addTask(taskData);
              print(res);
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
