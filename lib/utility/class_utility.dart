part of modularity.core.utility;

class MethodCollection {
  Map<Symbol, Method> _methods = new Map<Symbol, Method>();
  InstanceMirror _instanceMirror;

  /// Initializes the collection
  MethodCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // get all methods
    instanceMirror.type.instanceMembers.forEach((name, mirror) {
      if(mirror.isRegularMethod && !mirror.isSetter && !mirror.isGetter && !mirror.isConstructor) {
        _methods[name] = new Method(name, mirror, _instanceMirror);
      }
    });
  }

  /// Returns true if the collection contains a method with the given [name]
  bool contains(Symbol name) => _methods.containsKey(name);

  /// Returns the [Method] for the given [name] or null if [name] is not in the collection
  Method operator [](Symbol name) => _methods[name];

  /// Returns the first method that satisfies the given [test]
  Method firstWhere(bool test(Method method), { Method orElse() }) {
    return _methods.values.firstWhere(test, orElse: orElse);
  }

  /// Returns each method that satisfies the given [test]
  Iterable<Method> where(bool test(Method method)) {
    return _methods.values.where(test);
  }

  /// Invokes each method that satisfies the given [test]
  void invokeWhere(bool test(Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _methods.values.forEach((method) {
      if(test(method)) {
        method.invoke(positionalArguments, namedArguments);
      }
    });
  }

  /// Invokes the first method that satisfies the given [test]
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

  /// Initializes the method
  Method(this.name, MethodMirror methodMirror, InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;
    _methodMirror = methodMirror;
  }

  /// Invokes the method
  void invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror.invoke(name, positionalArguments, namedArguments);
  }

  /// Returns true if method is abstract
  bool get isAbstract => _methodMirror.isAbstract;

  /// Returns the 'metadata annotation' for the given [annotationName]
  /// or null if method is not annotated with the annotation with the given name
  operator [](Symbol annotationName) {
    var metadata = _methodMirror.metadata.firstWhere((meta) {
      return meta.type.simpleName == annotationName;
    }, orElse: () => null);

    return metadata != null ? metadata.reflectee : null;
  }

  /// Returns true if the method is annotated with
  /// the metadata annotation with the given [name]
  bool hasMetadata(Symbol name) => this[name] != null;
}

class FieldCollection {
  Map<Symbol, Field> _fields = new Map<Symbol, Field>();
  InstanceMirror _instanceMirror;

  /// Initializes the collection
  FieldCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // get all fields
    instanceMirror.type.instanceMembers.forEach((name, mirror) {
      if(mirror.isSetter || mirror.isGetter) {
        _fields[name] = new Field(name, _instanceMirror);
      }
    });
  }

  /// Returns the [Field] for the given [name] or null if [name] is not in the collection
  Field operator [](Symbol name) {
    return _fields[name];
  }

  /// Associates the [Field] with the given [name] with the given [value]
  operator []=(Symbol name, Object value) => _instanceMirror.setField(name, value);

  /// Returns true if the collection contains a [Field] with the given [name]
  bool contains(Symbol name) => _fields.containsKey(name);
}

class Field {
  InstanceMirror _instanceMirror;
  MethodMirror _methodMirror;
  final Symbol name;

  /// Initializes the field
  Field(this.name, InstanceMirror instanceMirror) {
    _methodMirror = instanceMirror.type.instanceMembers[name];
    _instanceMirror = instanceMirror;
  }

  /// Sets the given [value]
  set(Object value) => _instanceMirror.setField(name, value);

  /// Gets the value of the [Field]
  Object get() => _instanceMirror.getField(name);

  /// Returns true if [Field] is a setter
  bool get isSetter => _methodMirror.isSetter;

  /// Returns true if [Field] is a getter
  bool get isGetter => _methodMirror.isGetter;
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

  bool hasField(Symbol name) => _fields.contains(name);

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
