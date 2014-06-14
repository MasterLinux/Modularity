part of lib.core.exception;

class MissingModuleException {
  final String moduleName;

  MissingModuleException(this.moduleName);

  String toString() {
    return "Module [$moduleName] is missing";
  }
}
