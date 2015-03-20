part of modularity.core.utility;

class FieldCollection {
  InstanceMirror _instanceMirror;

  FieldCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;
  }

  Field operator [](Symbol name) {
    return new Field(name, _instanceMirror);
  }

  operator []=(Symbol name, Object value) => _instanceMirror.setField(name, value);
}

class Field {
  InstanceMirror _instanceMirror;
  final Symbol name;

  Field(this.name, InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;
  }

  set(Object value) => _instanceMirror.setField(name, value);

  Object get() => _instanceMirror.getField(name);
}

/**
 * TODO:
 * var classLoader = new ClassLoader("lib", "class");
 * classLoader.methods.firstWhere((Symbol name, dynamic annotation) => true).invoke([], {});
 * classLoader.methods.whereName("method").invoke([], {});
 * classLoader.fields.whereName("field").set(1);
 * classLoader.fields.whereName("field").get(defaultValue: 1);
 */
class ClassLoader<T> {
  InstanceMirror _instanceMirror;
  ClassMirror _classMirror;
  FieldCollection _fields;

  ClassLoader(Symbol libraryName, Symbol className, [Symbol constructorName, List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _classMirror = _getClassMirror(libraryName, className);

    constructorName = constructorName != null ? constructorName : const Symbol('');
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror = _classMirror.newInstance(constructorName, positionalArguments, namedArguments);

    _fields = new FieldCollection(_instanceMirror);
  }

  ClassLoader.fromInstance(T reflectee) {
    _instanceMirror = reflect(reflectee);
    _classMirror = _instanceMirror.type;

    _fields = new FieldCollection(_instanceMirror);
  }

  /// Gets the instance of the loaded class
  T get instance => _instanceMirror.reflectee as T;

  FieldCollection get fields => _fields;


  /**
   * Invokes a method by its [name]
   */
  void invokeMethod(Symbol name, [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror.invoke(name, positionalArguments, namedArguments);
  }

  /**
   * Invokes the first occurrence of the method which
   * is annotated with a specific annotation
   */
  void invokeAnnotatedMethod(Symbol annotationName, {List positionalArguments, Map<Symbol,dynamic> namedArguments, bool condition(annotation)}) {
    var instanceMembers = _instanceMirror.type.instanceMembers;

    var methodMirror = instanceMembers.values.firstWhere((MethodMirror methodMirror) {
      return _isAnnotatedMethod(methodMirror, annotationName, condition);
    }, orElse: () => null);

    if(methodMirror != null) {
      invokeMethod(
          methodMirror.simpleName,
          positionalArguments,
          namedArguments
      );
    }
  }

  /**
   * Invokes each method which is
   * annotated with a specific annotation
   */
  void invokeAnnotatedMethods(Symbol annotationName, {List positionalArguments, Map<Symbol,dynamic> namedArguments, bool condition(annotation)}) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};
    var instanceMembers = _instanceMirror.type.instanceMembers;

    instanceMembers.forEach((Symbol methodName, MethodMirror methodMirror) {
      if(_isAnnotatedMethod(methodMirror, annotationName, condition)) {
        invokeMethod(
          methodName,
          positionalArguments,
          namedArguments
        );
      }
    });
  }

  /**
   * Gets the mirror of a specific class with the help of
   * its [libraryName] and [className].
   */
  ClassMirror _getClassMirror(Symbol libraryName, Symbol className) {
    ClassMirror reflectedClass;

    var mirrorSystem = currentMirrorSystem();
    var library = mirrorSystem.findLibrary(libraryName);

    if((reflectedClass = library.declarations[className]) != null) {
      return reflectedClass;
    } else {
      throw new MissingClassException(className.toString());
    }
  }

  /**
   * Checks whether the given method is annotated with a specific annotation
   */
  bool _isAnnotatedMethod(MethodMirror methodMirror, Symbol annotationSymbol, bool condition(annotation)) {
    condition = condition != null ? condition : (a) => true;
    var hasAnnotation = false;

    if(methodMirror.isRegularMethod) {

      var annotation = methodMirror.metadata.firstWhere((meta) {
        return meta.hasReflectee &&
          meta.type.simpleName == annotationSymbol &&
          condition(meta.reflectee);
      }, orElse: () => null);

      if(annotation != null) {
        hasAnnotation = true;
      }
    }

    return hasAnnotation;
  }
}

class MissingClassException implements Exception {
  final String className;

  MissingClassException(this.className);

  String toString() {
    return "Class [$className] is missing";
  }
}
