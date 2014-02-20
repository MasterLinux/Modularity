part of lib.core;

class MissingModuleNameException implements Exception {

  String toString() {
    return "Module name could not be null";
  }
}
