import '../entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<List<Task>> getAllTasks();
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
}