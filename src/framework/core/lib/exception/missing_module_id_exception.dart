part of lib.core;

class MissingModuleIdException implements Exception {

  String toString() {
    return "Module id could not be null";
  }
}
