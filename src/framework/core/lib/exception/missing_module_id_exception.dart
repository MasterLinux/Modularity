part of modularity.core.exception;

class MissingModuleIdException implements Exception {

  String toString() {
    return "Module id could not be null";
  }
}
