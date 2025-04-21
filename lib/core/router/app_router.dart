import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/router/routes.dart';
import 'package:task_manager/core/services/service_locator.dart';
import 'package:task_manager/features/tasks/data/repository/task_repository_impl.dart';
import 'package:task_manager/features/tasks/domain/usecases/add_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:task_manager/features/tasks/domain/usecases/update_task.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';
import 'package:task_manager/features/tasks/prsentation/pages/home_page.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        // return MaterialPageRoute(
        //   builder: (context) => BlocProvider<TaskBloc>.value(
        //     value: sl<TaskBloc>(),
        //     child: const HomePage(),
        //   ),
        // );
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
