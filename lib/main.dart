import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/router/app_router.dart';
import 'package:task_manager/core/router/routes.dart';
import 'package:task_manager/core/services/service_locator.dart';
import 'package:task_manager/core/services/shared_preferences.dart';
import 'package:task_manager/core/styles/app_theme.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  await SharedPreferencesService.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (_) => sl<TaskCubit>()..loadTasks(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      final ThemeMode currentThemeMode;

      // Map ThemeState to ThemeMode
      switch (themeState) {
        case ThemeState.light:
          currentThemeMode = ThemeMode.light;
          break;
        case ThemeState.dark:
          currentThemeMode = ThemeMode.dark;
          break;
        case ThemeState.system:
        default:
          currentThemeMode = ThemeMode.system;
          break;
      }

      return MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: currentThemeMode,
        onGenerateRoute: sl<AppRouter>().onGenerateRoute,
        initialRoute: Routes.HOME,
      );
    });
  }
}
