import 'package:flutter/material.dart';

class BuildEmptyState extends StatelessWidget {
  const BuildEmptyState({super.key, required this.filter});

  final String filter;
  @override
  Widget build(BuildContext context) {
    String message;

    switch (filter) {
      case 'completed':
        message = 'No completed tasks';
        break;
      case 'pending':
        message = 'No tasks in progress';
        break;
      case 'all':
      default:
        message = 'No tasks added yet';
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]
                : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Add tasks to get started',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[500]
                  : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
