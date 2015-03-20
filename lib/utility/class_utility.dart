part of modularity.core.utility;

class MethodCollection {
  Map<Symbol, Method> _methods = new Map<Symbol, Method>();
  InstanceMirror _instanceMirror;

  MethodCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // get all methods
    instanceMirror.type.instanceMembers.forEach((name, mirror) {
      if(mirror.isRegularMethod && !mirror.isSetter && !mirror.isGetter && !mirror.isConstructor) {
        _methods[name] = new Method(name, mirror, _instanceMirror);
      }
    });
  }

  bool contains(Symbol name) => _methods.containsKey(name);

  Method operator [](Symbol name) {
    return _methods[name];
  }

  Method firstWhere(bool test(Method method), { Method orElse() }) {
    return _methods.values.firstWhere(test, orElse: orElse);
  }

  Iterable<Method> where(bool test(Method method)) {
    return _methods.values.where(test);
  }

  void invokeWhere(bool test(Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _methods.values.forEach((method) {
      if(test(method)) {
        method.invoke(positionalArguments, namedArguments);
      }
    });
  }

  void invokeFirstWhere(bool test(Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    var method = firstWhere(test, orElse: () => null);

    if(method != null) {
      method.invoke(positionalArguments, namedArguments);
    }
  }
}

class Method {
  InstanceMirror _instanceMirror;
  MethodMirror _methodMirror;
  final Symbol name;

  Method(this.name, MethodMirror methodMirror, InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;
    _methodMirror = methodMirror;
  }

  void invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror.invoke(name, positionalArguments, namedArguments);
  }

  bool get isAbstract => _methodMirror.isAbstract;

  /// Gets a specific annotation by its [metadataName]. If annotation
  /// does not exists it returns [null]
  operator [](Symbol metadataName) {
    var metadata = _methodMirror.metadata.firstWhere((meta) {
      return meta.type.simpleName == metadataName;
    }, orElse: () => null);

    return metadata.reflectee;
  }

  bool hasMetadata(Symbol name) => this[name] != null;
}

class FieldCollection {
  InstanceMirror _instanceMirror;

  FieldCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // TODO create field map, see methodColl
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

  bool get isSetter => false; // TODO implement

  bool get isGetter => true; // TODO implement
}

///
class ClassLoader<T> {
  InstanceMirror _instanceMirror;
  ClassMirror _classMirror;
  FieldCollection _fields;
  MethodCollection _methods;

  /// Initializes the loader with the help of the [libraryName]
  /// and [className] of the required class to load. The [constructorName]
  /// can be used to use a specific constructor for initialization
  ClassLoader(Symbol libraryName, Symbol className, [Symbol constructorName, List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _classMirror = _getClassMirror(libraryName, className);

    constructorName = constructorName != null ? constructorName : const Symbol('');
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror = _classMirror.newInstance(constructorName, positionalArguments, namedArguments);

    _fields = new FieldCollection(_instanceMirror);
    _methods = new MethodCollection(_instanceMirror);
  }

  /// Initializes the loader with the help of an instance
  ClassLoader.fromInstance(T reflectee) {
    _instanceMirror = reflect(reflectee);
    _classMirror = _instanceMirror.type;

    _fields = new FieldCollection(_instanceMirror);
    _methods = new MethodCollection(_instanceMirror);
  }

  /// Gets the instance of the loaded class
  T get instance => _instanceMirror.reflectee as T;

  FieldCollection get fields => _fields;

  MethodCollection get methods => _methods;

  bool hasField(Symbol name) => true; //TODO implement

  bool hasMethod(Symbol name) => _methods.contains(name);

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
