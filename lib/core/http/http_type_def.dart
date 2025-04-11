import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/http_failure.dart';

typedef FutureEither<T> = Future<Either<HttpFailure, T>>;
typedef FutureEitherVoid = Future<Either<HttpFailure, void>>;
typedef FutureVoid = Future<void>;
