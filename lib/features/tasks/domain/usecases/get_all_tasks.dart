import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;
  GetAllTasks(this.repository);

  Future<List<Task>> call() => repository.getAllTasks();
}