part of modularity.core.exception;

class MissingInitMethodException implements Exception {
  final String moduleName;

  MissingInitMethodException(this.moduleName);

  String toString() {
    return "Init method of module [$moduleName] is missing";
  }
}
