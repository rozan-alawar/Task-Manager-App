import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/extentions/space_extention.dart';
import 'package:task_manager/features/tasks/domain/entities/task.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/add_new_task_button.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/empty_state_widget.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/filter_btn.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/home_header.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/progress_indecator.dart';
import 'package:task_manager/features/tasks/prsentation/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentFilter = 'all';
  final _taskController = TextEditingController();
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
                              return TaskItem(task: task);
                            },
                          ),
                  ),
                ),
                // _buildAddTaskSection(),
                const AddTaskButton(),
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
          FilterButton(
            title: 'All',
            filter: 'all',
            currentFilter: currentFilter,
          ),
          const SizedBox(width: 8),
          FilterButton(
            title: 'In Progress',
            filter: 'pending',
            currentFilter: currentFilter,
          ),
          const SizedBox(width: 8),
          FilterButton(
            title: 'Completed',
            filter: 'completed',
            currentFilter: currentFilter,
          ),
        ],
      ),
    );
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
