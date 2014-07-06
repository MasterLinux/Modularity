part of modularity.template.exception;

class NotSupportedElementException implements Exception { //TODO rename to UnsupportedElementException?
  final String tag;

  NotSupportedElementException(this.tag);

  String toString() {
    return "The element of type [$tag] is currently not supported.";
  }
}
