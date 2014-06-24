part of lib.core.exception;

class MissingLibraryException implements Exception {
  final String libraryName;

  MissingLibraryException(this.libraryName);

  String toString() {
    return "Library [$libraryName] is missing";
  }
}
