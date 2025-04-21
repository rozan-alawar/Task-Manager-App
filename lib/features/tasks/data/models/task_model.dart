import 'dart:convert';

import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.isDone,
  });

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      isDone: task.isDone,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  static String encodeList(List<TaskModel> tasks) {
    return json.encode(tasks.map((task) => task.toJson()).toList());
  }

  static List<TaskModel> decodeList(String tasksString) {
    List<dynamic> tasksJson = json.decode(tasksString);
    return tasksJson.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
  }
}
