import 'package:get_it/get_it.dart';
import 'package:task_manager/core/router/app_router.dart';
import 'package:task_manager/core/services/shared_preferences.dart';
import 'package:task_manager/features/tasks/data/data_source/task_local_data_source.dart';
import 'package:task_manager/features/tasks/data/repository/task_repository_impl.dart';
import 'package:task_manager/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_manager/features/tasks/domain/usecases/add_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_manager/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:task_manager/features/tasks/domain/usecases/update_task.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/task_cubit.dart';
import 'package:task_manager/features/tasks/prsentation/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  //Cubits
  sl.registerLazySingleton(
    () => TaskCubit(
      AddTask(sl()),
      GetAllTasks(sl()),
      DeleteTask(sl()),
      UpdateTask(sl()),
    ),
  );

  sl.registerLazySingleton(() => ThemeCubit());

  // Use cases
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  // Core services
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(),
  );

  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(),
  );
}
