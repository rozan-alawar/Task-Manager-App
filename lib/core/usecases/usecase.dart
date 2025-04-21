import 'package:dartz/dartz.dart';
import 'package:task_manager/core/errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
