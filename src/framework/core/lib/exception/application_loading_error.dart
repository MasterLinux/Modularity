part of lib.core.exception;

class ApplicationLoadingError {
  final String message = "The application could not be loaded.";

  ApplicationLoadingError();

  String toString() {
    return message;
  }
}
