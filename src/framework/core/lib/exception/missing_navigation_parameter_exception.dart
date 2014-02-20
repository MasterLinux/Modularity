part of lib.core;

class MissingNavigationParameterException implements Exception {
  final String name;

  MissingNavigationParameterException(this.name);

  String toString() {
    if(name == null) {
      return "The name of a navigation parameter may not be null";
    }

    return "The navigation parameter [$name] is missing";
  }
}