import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:task_manager/features/tasks/domain/usecases/add_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:task_manager/features/tasks/domain/usecases/update_task.dart';

class TaskCubit extends Cubit<List<Task>> {
  final AddTask addTaskUseCase;
  final GetAllTasks getAllTasksUseCase;
  final DeleteTask deleteTaskUseCase;
  final UpdateTask updateTaskUseCase;

  TaskCubit(this.addTaskUseCase, this.getAllTasksUseCase,
      this.deleteTaskUseCase, this.updateTaskUseCase)
      : super([]);

  Future<void> loadTasks() async {
    try {
      final tasks = await getAllTasksUseCase();

      emit(List<Task>.from(tasks));
    } catch (e) {
      print('Error loading tasks: $e');

      emit([]);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await addTaskUseCase(task);

      final updatedTasks = await getAllTasksUseCase();

      emit(List<Task>.from(updatedTasks));
    } catch (e) {
      print('Error adding task: $e');

      await loadTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await deleteTaskUseCase(id);

      final updatedTasks = await getAllTasksUseCase();

      emit(List<Task>.from(updatedTasks));
    } catch (e) {
      print('Error deleting task: $e');

      await loadTasks();
    }
  }

  Future<void> toggleTaskDone(Task task) async {
    try {
      final updatedTask = task.copyWith(isDone: !task.isDone);
      await updateTaskUseCase(updatedTask);

      final updatedTasks = await getAllTasksUseCase();

      emit(List<Task>.from(updatedTasks));
    } catch (e) {
      print('Error toggling task: $e');

      await loadTasks();
    }
  }

  Future<void> updateTaskTitle(Task task, String newTitle) async {
    if (newTitle.isEmpty) return;

    try {
      final updatedTask = task.copyWith(title: newTitle);
      await updateTaskUseCase(updatedTask);

      final updatedTasks = await getAllTasksUseCase();

      emit(List<Task>.from(updatedTasks));
    } catch (e) {
      print('Error updating task title: $e');

      await loadTasks();
    }
  }

  double getCompletionPercentage() {
    if (state.isEmpty) return 0.0;

    int completedTasks = state.where((task) => task.isDone).length;
    return completedTasks / state.length;
  }

  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case 'completed':
        return state.where((task) => task.isDone).toList();
      case 'pending':
        return state.where((task) => !task.isDone).toList();
      case 'all':
      default:
        return state;
    }
  }
}
