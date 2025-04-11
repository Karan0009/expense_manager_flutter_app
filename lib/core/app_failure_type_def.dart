import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/app_failure.dart';

typedef FutureAppFailureEither<T> = Future<Either<AppFailure, T>>;
typedef FutureAppFailureEitherVoid = Future<Either<AppFailure, void>>;
