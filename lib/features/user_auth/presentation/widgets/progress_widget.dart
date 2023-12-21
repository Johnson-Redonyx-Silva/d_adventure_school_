import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressWidget extends StatefulWidget {
  final String title;
  final String text;
  const ProgressWidget({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Set the elevation for the shadow
      shadowColor: Colors.black, // Customize the shadow color if needed
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            CircularPercentIndicator(
              radius: 50,
              lineWidth: 20,
              progressColor: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              percent: 0.4,
              center: Text(
                '40%',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
