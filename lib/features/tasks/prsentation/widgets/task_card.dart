import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: task.isDone ? Colors.green : Colors.red,
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        leading: InkWell(
          onTap: () {
            context.read<TaskCubit>().toggleTaskDone(task);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: task.isDone ? Colors.green : Colors.grey,
              ),
            ),
            child: task.isDone
                ? const Icon(Icons.check, color: Colors.green, size: 18)
                : const SizedBox(width: 18, height: 18),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                final controller = TextEditingController(text: task.title);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Edit Task'),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<TaskCubit>()
                              .updateTaskTitle(task, controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                context.read<TaskCubit>().deleteTask(task.id);
              },
            ),
          ],
        ),
        subtitle: Text(
          task.isDone ? 'Completed' : 'In Progress',
          style: TextStyle(
            color: task.isDone ? Colors.green : Colors.orange,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
