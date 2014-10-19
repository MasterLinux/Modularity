library modularity.core.exception;

part 'invalid_module_exception.dart';
part 'missing_init_method_exception.dart';
part 'missing_library_exception.dart';
part 'missing_module_exception.dart';
part 'missing_module_id_exception.dart';
part 'missing_config_argument_exception.dart';
part 'application_loading_exception.dart';

class ExecutionException implements Exception {
  final String message;

  ExecutionException(this.message);

  String toString() {
    return message;
  }
}