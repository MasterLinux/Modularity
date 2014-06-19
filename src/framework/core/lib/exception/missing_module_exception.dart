part of lib.core.exception;

class MissingModuleException implements Exception {
  final String moduleName;

  MissingModuleException(this.moduleName);

  String toString() {
    return "Module [$moduleName] is missing";
  }
}
