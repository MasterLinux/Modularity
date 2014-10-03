part of modularity.core.exception;

class ApplicationLoadingException implements Exception {
  final String message = "The application could not be loaded.";

  ApplicationLoadingException();

  String toString() {
    return message;
  }
}
