part of lib.core.exception;

class InvalidModuleException implements Exception {
  String _name;

  InvalidModuleException(Symbol symbol) {
    _name = symbol != null ? symbol.toString() : null;
  }

  String toString() {
    if(_name == null) {
      return "Object symbol may not be null";
    }

    return 'Object type [$_name] is not a valid module, because the @Module annotation is missing';
  }
}
