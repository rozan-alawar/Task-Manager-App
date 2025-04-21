import 'package:task_manager/features/tasks/data/data_source/task_local_data_source.dart';
import 'package:task_manager/features/tasks/data/models/task_model.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:task_manager/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.addTask(taskModel);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final tasks = await localDataSource.getTasks();
      return tasks;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(Task updatedTask) async {
    final taskModel = TaskModel.fromEntity(updatedTask);
    await localDataSource.updateTask(taskModel);
  }
}
