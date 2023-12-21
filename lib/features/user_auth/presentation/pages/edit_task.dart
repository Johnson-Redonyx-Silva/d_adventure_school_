import 'package:d_adventure_school/utils/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTask extends StatefulWidget {
  final Map<String, dynamic> taskDetails;
  const EditTask({Key? key, required this.taskDetails}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var loginUser = '';
  String selectedUsername = '';
  String selectedUid = '';
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getLoginUser();
    patchValues();
  }

  patchValues() async {
    setState(() {
      this.selectedUsername = widget.taskDetails['username'];
      this.selectedUid = widget.taskDetails['uid'];
      _taskNameController.text = widget.taskDetails['taskName'];
      _taskDescController.text = widget.taskDetails['task_des'];
    });
    print(this.selectedUid);
  }

  getLoginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginUser = prefs.getString('username').toString();
  }

  @override
  void dispose() {
    super.dispose();
    _taskNameController.dispose();
    _taskDescController.dispose();
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
        title: const Text("Edit Task"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 100,
                      child: Row(
                        children: [
                          const Text("Username"),
                          const Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
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
                                // height: 200,
                                // child: ListView.builder(
                                //   itemCount: userDataTemp.length,
                                //   itemBuilder: (context, index) {
                                //     final user = userDataTemp[index];
                                //     return ListTile(
                                //       title: Text(user['username']),
                                //       trailing: (selectedUid == user['uid'])
                                //           ? const Icon(Icons.check)
                                //           : null,
                                //       onTap: () {
                                //         setState(() {
                                //           selectedUsername = user['username'];
                                //           selectedUid = user['uid'];
                                //         });
                                //         Navigator.pop(context);
                                //       },
                                //     );
                                //   },
                                // ),
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
                      child: Container(
                          width: 100,
                          child: Row(
                            children: [
                              const Text("Task"),
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
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
                      child: Container(
                          child: Row(
                        children: [
                          const Text("Task Description"),
                          const Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
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
                      'assignedBy': loginUser
                    };
                    var res =
                        await editTask(widget.taskDetails['taskId'], taskData);
                    print(res);

                    Navigator.pop(context);
                    _showSnackBar('Task Edited successfully');
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
