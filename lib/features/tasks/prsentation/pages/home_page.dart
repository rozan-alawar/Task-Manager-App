import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/extentions/space_extention.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/empty_state_widget.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/home_header.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/progress_indecator.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentFilter = 'all';
  final _taskController = TextEditingController();
  bool _showAddTaskInput = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    await context.read<TaskCubit>().loadTasks();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BlocConsumer<TaskCubit, List<Task>>(
          listener: (context, state) {
            print("State updated with ${state.length} tasks");
          },
          builder: (context, tasks) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Task> filteredTasks = _filterTasks(tasks, currentFilter);

            double progress = tasks.isEmpty
                ? 0
                : tasks.where((task) => task.isDone).length / tasks.length;

            return Column(
              children: [
                20.height,
                const HomeHeaderWidget(),
                20.height,
                ProgressIndecatorWidget(progress: progress),
                const SizedBox(height: 20),
                _buildFilterButtons(),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<TaskCubit>().loadTasks();
                    },
                    child: filteredTasks.isEmpty
                        ? ListView(
                            children: [
                              BuildEmptyState(filter: currentFilter),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              return _buildTaskItem(context, task);
                            },
                          ),
                  ),
                ),
                _buildAddTaskSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterButton('All', 'all'),
          const SizedBox(width: 8),
          _filterButton('In Progress', 'pending'),
          const SizedBox(width: 8),
          _filterButton('Completed', 'completed'),
        ],
      ),
    );
  }

  Widget _filterButton(String title, String filter) {
    final isSelected = currentFilter == filter;

    return InkWell(
      onTap: () {
        setState(() {
          currentFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
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

  Widget _buildAddTaskSection() {
    if (_showAddTaskInput) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    hintText: 'Write task title...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addNewTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Add'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _taskController.clear();
                    _showAddTaskInput = false;
                  });
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _showAddTaskInput = true;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Task'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      );
    }
  }

  void _addNewTask() {
    if (_taskController.text.isNotEmpty) {
      final task = Task(
        id: const Uuid().v4(),
        title: _taskController.text,
        isDone: false,
      );
      context.read<TaskCubit>().addTask(task);
      _taskController.clear();
      setState(() {
        _showAddTaskInput = false;
      });
    }
  }

  List<Task> _filterTasks(List<Task> tasks, String filter) {
    switch (filter) {
      case 'completed':
        return tasks.where((task) => task.isDone).toList();
      case 'pending':
        return tasks.where((task) => !task.isDone).toList();
      case 'all':
      default:
        return tasks;
    }
  }
}
