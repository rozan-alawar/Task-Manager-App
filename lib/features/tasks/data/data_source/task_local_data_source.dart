import 'dart:convert';

import 'package:task_manager/core/errors/failure.dart';
import 'package:task_manager/core/services/shared_preferences.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(String id);
  Future<Task> addTask(Task task);
  Future<Task> updateTask(Task task);
  Future<bool> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final String tasksKey = 'TASKS_KEY';

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      await SharedPreferencesService.init();

      final jsonString = SharedPreferencesService.getData(key: tasksKey);
      print('Retrieved tasks data: ${jsonString ?? 'null'}');

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final tasks = jsonList.map((json) => TaskModel.fromJson(json)).toList();
        print('Parsed ${tasks.length} tasks from storage');
        return tasks;
      }

      print('No tasks found in storage, returning empty list');
      return [];
    } catch (e) {
      print('Error retrieving tasks: $e');
      throw CacheFailure('Failed to retrieve tasks from cache: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final tasks = await getTasks();
      final task = tasks.firstWhere(
        (Task task) => task.id == id,
        orElse: () => throw const CacheFailure('Task not found'),
      );
      return TaskModel.fromEntity(task);
    } catch (e) {
      throw CacheFailure('Failed to get task: ${e.toString()}');
    }
  }

  @override
  Future<TaskModel> addTask(Task task) async {
    try {
      final tasks = await getTasks();
      print('Adding new task with title: ${task.title}');

      final taskWithId = TaskModel(
        id: task.id.isEmpty ? const Uuid().v4() : task.id,
        title: task.title,
        isDone: task.isDone,
      );

      final updatedTasks = List<TaskModel>.from(tasks);
      updatedTasks.add(taskWithId);

      final taskJsonList = updatedTasks.map((t) => t.toJson()).toList();
      final jsonString = json.encode(taskJsonList);

      print('Saving ${updatedTasks.length} tasks to storage');
      print('JSON data: $jsonString');

      await SharedPreferencesService.init();

      final success = await SharedPreferencesService.saveData(
        key: tasksKey,
        value: jsonString,
      );

      if (success) {
        print('Task added successfully');
        return taskWithId;
      } else {
        throw const CacheFailure('Failed to save task');
      }
    } catch (e) {
      print('Error adding task: $e');
      throw CacheFailure('Failed to add task: ${e.toString()}');
    }
  }

  @override
  Future<TaskModel> updateTask(Task task) async {
    try {
      final tasks = await getTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);
      print('Updating task with id: ${task.id}, found at index: $index');

      if (index >= 0) {
        final taskModel = TaskModel.fromEntity(task);

        final updatedTasks = List<TaskModel>.from(tasks);
        updatedTasks[index] = taskModel;

        final taskJsonList = updatedTasks.map((t) => t.toJson()).toList();
        final jsonString = json.encode(taskJsonList);

        print('Saving ${updatedTasks.length} tasks to storage after update');

        await SharedPreferencesService.init();

        final success = await SharedPreferencesService.saveData(
          key: tasksKey,
          value: jsonString,
        );

        if (success) {
          print('Task updated successfully');
          return taskModel;
        } else {
          throw const CacheFailure('Failed to update task');
        }
      } else {
        throw const CacheFailure('Task not found');
      }
    } catch (e) {
      print('Error updating task: $e');
      throw CacheFailure('Failed to update task: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    try {
      final tasks = await getTasks();
      final initialLength = tasks.length;
      print('Deleting task with id: $id, current task count: $initialLength');

      final updatedTasks = tasks.where((task) => task.id != id).toList();
      print('After deletion: ${updatedTasks.length} tasks remaining');

      if (updatedTasks.length != initialLength) {
        final taskJsonList = updatedTasks.map((t) => t.toJson()).toList();
        final jsonString = json.encode(taskJsonList);

        await SharedPreferencesService.init();

        final success = await SharedPreferencesService.saveData(
          key: tasksKey,
          value: jsonString,
        );

        print('Task deletion save result: $success');
        return success;
      } else {
        print('No task found with id: $id');
        return false;
      }
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }
}
