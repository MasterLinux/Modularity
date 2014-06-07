part of lib.core.exception;

class MissingLibraryException {
  final String libraryName;

  MissingLibraryException(this.libraryName);

  String toString() {
    return "Library [$libraryName] is missing";
  }
}
