import 'package:flutter/material.dart';
import '../../../../utils/firebase_service.dart';

class AddTasks extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskAdded;

  const AddTasks({Key? key, required this.onTaskAdded}) : super(key: key);

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  List<Map<String, dynamic>> userDataTemp = [];

  String selectedUsername = '';
  String selectedUid = '';
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 100, child: Row(
                    children: [
                      const Text("Username"),
                      const Text("*",style: TextStyle(color: Colors.red),),
                    ],
                  )),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(width: 100, child: Row(
                        children: [
                          const Text("Task"),
                          const Text("*",style: TextStyle(color: Colors.red),),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _taskNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      Container(child: Row(
                        children: [
                          const Text("Task Description"),
                          const Text("*",style: TextStyle(color: Colors.red),),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _taskDescController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
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
                  if (_formKey.currentState?.validate() ?? false) {
                    if (selectedUid.isEmpty) {
                      _showSnackBar('Please select a username');
                      return;
                    }

                    var taskData = {
                      'uid': selectedUid,
                      'username': selectedUsername,
                      'taskName': _taskNameController.text,
                      'task_des': _taskDescController.text,
                    };
                    var res = await addTask(taskData);
                    print(res);

                    widget.onTaskAdded(taskData);
                    Navigator.pop(context);
                    _showSnackBar('Task added successfully');
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
