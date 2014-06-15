part of lib.core.exception;

class MissingConfigArgumentException { //TODO instead of using argument find another name -> property ?
  final String argumentName;

  MissingConfigArgumentException(this.argumentName);

  String toString() {
    return "Config argument $argumentName is missing";
  }
}
