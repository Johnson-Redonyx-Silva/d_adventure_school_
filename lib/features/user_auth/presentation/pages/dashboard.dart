import 'package:d_adventure_school/features/user_auth/presentation/widgets/progress_widget.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User name',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'user_id 12345',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: CircleAvatar(
                      maxRadius: 40.0,
                      backgroundImage: NetworkImage(
                          'https://cdn5.vectorstock.com/i/1000x1000/17/54/faces-avatar-in-circle-portrait-young-boy-vector-12511754.jpg'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 252, 247, 246),
                      border: Border.all(
                        color: const Color.fromARGB(255, 143, 79, 55),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius:
                              2.0, // How wide the shadow should spread
                          blurRadius: 5.0, // How much the shadow should blur
                          offset: Offset(
                              0, 3), // Changes the direction of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'task  completed',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 252, 247, 246),
                      border: Border.all(
                        color: const Color.fromARGB(255, 143, 79, 55),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius:
                              2.0, // How wide the shadow should spread
                          blurRadius: 5.0, // How much the shadow should blur
                          offset: Offset(
                              0, 3), // Changes the direction of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'task  completed',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  Text(
                    'Task',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  )
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              ProgressWidget(title: 'Daily task', text: 'Complete percentage'),
              const SizedBox(
                height: 10,
              ),
              ProgressWidget(
                  title: 'Monthly task', text: 'Complete percentage'),
            ],
          ),
        ),
      ),
    );
  }
}
