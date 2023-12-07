import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<List<Map<String, dynamic>>> getUsers() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> allUsers = [];

  try {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await firestore.collection('users').get();

    // Loop through the documents to access user data
    for (QueryDocumentSnapshot<Map<String, dynamic>> user
        in usersSnapshot.docs) {
      // Access user data using user.data()
      Map<String, dynamic> userData = user.data();

      // Example: Print user ID
      print('userData: $userData');

      // Add user data to the list
      allUsers.add(userData);
    }

    // Return the list of all users
    return allUsers;
  } catch (e) {
    print('Error retrieving users: $e');
    return [];
  }
}

Future<String> addTask(data) async {
  final taskId = const Uuid().v1();
  // ignore: unused_local_variable
  String res = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  print('data : $data["uid"]');
  try {
    final CollectionReference tasksCollection = firestore.collection('tasks');
    final DocumentReference taskDocument = tasksCollection.doc(taskId);

    await taskDocument.set({
      'uid': data['uid'],
      'username': data['username'],
      'taskId': taskId,
      'taskName': data['taskName'],
      'task_des': data['task_des'],
      'createdAt': FieldValue.serverTimestamp(), // Add this line for timestamp
    });

    return res = 'task stored';
  } catch (e) {
    return res = e.toString();
  }
}
