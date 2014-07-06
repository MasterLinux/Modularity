part of modularity.template.exception;

class MissingBindingException implements Exception {
  MissingBindingException();

  String toString() {
    return "The binding must not be null.";
  }
}
