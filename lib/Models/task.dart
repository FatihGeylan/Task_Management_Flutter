import 'dart:convert';
import 'package:flutter/material.dart';

class Task{
  String name;
  String description;
  String category;
  String date;
  String start_time;
  String end_time;
  int? id;

  Task(this.name, this.description, this.category, this.date, this.start_time, this.end_time,{this.id});


  factory Task.fromJson(Map<String, dynamic> json) => Task(
    json['name'] as String,
    json['description'] as String,
    json['category'] as String,
    json['date'] as String,
    json['start_time'] as String,
    json['end_time'] as String,
  );


  Map<String, dynamic> toJson() => _taskToJson(this);

  @override
  String toString() => 'Task<$name>';

}

// Task _taskFromJson(Map<String, dynamic> json) {
//   return Task(
//     json['name'] as String,
//     json['description'] as String,
//     json['category'] as String,
//     json['date'] as String,
//     json['startTime'] as String,
//     json['endTime'] as String,
//   );
// }
// 2
Map<String, dynamic> _taskToJson(Task instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'date': instance.date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
    };

String getPrettyJSONString(Object jsonObject) {
  return const JsonEncoder.withIndent('  ').convert(jsonObject);
}

const String Function(Object jsonObject) displayTask = getPrettyJSONString;

class DisplayTasks extends StatefulWidget {
  const DisplayTasks({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Map<String, dynamic>> tasks;

  @override
  _DisplayTasksState createState() => _DisplayTasksState();
}

class _DisplayTasksState extends State<DisplayTasks> {
  List<Map<String, dynamic>> get tasks => widget.tasks;

  Widget displayRaw(Map<String, dynamic> raw) => Card(
    child: Container(
      padding: const EdgeInsets.all(15.0),
      //height: 150,
      child: Text(displayTask(raw)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: ListView(
        children: tasks.map<Widget>(displayRaw).toList(),
      ),
    );
  }
}

// class Task {
//   String category;
//   String date;
//   String description;
//   String endTime;
//   String name;
//   String startTime;
//   int? id;
//
//   Task(
//       this.category,
//         this.date,
//         this.description,
//         this.endTime,
//         this.name,
//         this.startTime,
//         {this.id,}
//       );
//
//
//
//
//   Task.fromJson(Map<String, dynamic> json) {
//     category = json['category'];
//     date = json['date'];
//     description = json['description'];
//     endTime = json['end_time'];
//     id = json['id'];
//     name = json['name'];
//     startTime = json['start_time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> hasura_queries_mutations = new Map<String, dynamic>();
//     hasura_queries_mutations['category'] = this.category;
//     hasura_queries_mutations['date'] = this.date;
//     hasura_queries_mutations['description'] = this.description;
//     hasura_queries_mutations['end_time'] = this.endTime;
//     hasura_queries_mutations['id'] = this.id;
//     hasura_queries_mutations['name'] = this.name;
//     hasura_queries_mutations['start_time'] = this.startTime;
//     return hasura_queries_mutations;
//   }
// }