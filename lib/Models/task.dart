import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task{
  String name;
  String description;
  String category;
  DateTime date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Task(this.name, this.description, this.category, this.date, this.startTime, this.endTime);

  factory Task.fromJson(Map<String, dynamic> json) =>
      _taskFromJson(json);

  Map<String, dynamic> toJson() => _taskToJson(this);

  @override
  String toString() => 'Task<$task>';

}

Task _taskFromJson(Map<String, dynamic> json) {
  return Task(
    name: json['name'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    starttime: (json['starttime'] as Timestamp).to
    date: (json['date'] as Timestamp).toDate(),
    done: json['done'] as bool,
  );
}
// 2
Map<String, dynamic> _vaccinationToJson(Vaccination instance) =>
    <String, dynamic>{
      'vaccination': instance.vaccination,
      'date': instance.date,
      'done': instance.done,
    };