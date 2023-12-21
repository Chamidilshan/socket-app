import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String taskName;
 // final String date;

  const TaskCard({
    super.key,
    required this.taskName,
   // required this.date
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.taskName,
            style: TextStyle(
              color: Colors.black
            ),
          ),
          // Text(
          //   widget.date,
          //   style: TextStyle(
          //     color: Colors.black
          //   ),
          // ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
