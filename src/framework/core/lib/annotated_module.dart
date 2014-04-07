part of lib.core;

class AnnotatedModule extends AbstractModule {
  ClassMirror _reflectedClass;
  InstanceMirror _instance;
  final String _name;
  final String _lib;
  String _author;
  String _company;
  String _eMail;
  String _website;
  String _version;

  /**
   * Initializes the module with the help
   * of a class which uses the module annotations.
   */
  AnnotatedModule(this._lib, this._name, Fragment fragment, Map<String, Object> config)
    : super(fragment, config);

  String get lib => _lib;

  String get name => _name;

  String get company => _company;

  String get eMail => _eMail;

  String get website => _website;

  String get version => _version;

  String get author => _author;

  /**
   * Invokes all event handler which are passed the given [test].
   */
  void _invokeHandlerWhere(bool test(InstanceMirror mirror), ClassMirror classMirror, InstanceMirror instanceMirror, [EventArgs args]) {
    classMirror.instanceMembers.forEach((Symbol methodName, MethodMirror methodMirror) {

      //check whether method is annotated
      if(methodMirror.isRegularMethod
        && methodMirror.metadata.isNotEmpty) {

        //get all methods to invoke
        var annotations = methodMirror.metadata.where(test);

        //invoke onInit method
        if(annotations.isNotEmpty) {
          if(args != null) {
            instanceMirror.invoke(methodName, [args]);
          } else {
            instanceMirror.invoke(methodName, []);
          }
        }
      }
    });
  }

  /**
   * Gets the class mirror of the required module with the help of
   * its [libraryName] and [className].
   */
  ClassMirror _getReflectedClass(String libraryName, String className) {
    Symbol librarySymbol = new Symbol(libraryName); //TODO is the usage of const Symbol('') possible?
    Symbol classSymbol = new Symbol(className); //TODO is the usage of const Symbol('') possible?
    ClassMirror reflectedClass;

    //get current mirror system
    var mirrors = currentMirrorSystem();

    //get required library mirror
    var libraryMirror = mirrors.libraries.values.firstWhere(
            (libraryMirror) => libraryMirror.qualifiedName == librarySymbol,
            orElse: () => null
    );

    if(libraryMirror != null
    && (reflectedClass = libraryMirror.declarations[classSymbol]) != null) {
      return reflectedClass;

    } else if(libraryMirror != null && reflectedClass == null) {
      //TODO throw missing class exception
    } else {
      //TODO throw missing library exception
    }
  }

  void _setModuleInfo(Module meta) {
      _version = meta.version;
      _author = meta.author;
      _eMail = meta.eMail;
      _company = meta.company;
      _website = meta.website;
  }

  @override
  void onInit(InitEventArgs args) {
    _reflectedClass = _getReflectedClass(lib, name);

    var metadata = _reflectedClass.metadata;
    var annotation = metadata.firstWhere(
      (meta) => meta.hasReflectee && meta.reflectee is Module,
      orElse: () => null
    );

    //get new instance of module to invoke methods
    _instance = _reflectedClass.newInstance(const Symbol(''), []);

    //get module information for registration
    if(annotation != null && name != null) {
      _setModuleInfo(annotation.reflectee as Module);

      //try to invoke onInit handler of module, if handler doesn't exists throw exception
      if(!_tryInvokeOnInitHandler(_reflectedClass, _instance, args)) {
        throw new MissingInitMethodException(name);
      }
    }

    //if name is missing throw exception
    else if(annotation != null && name == null) {
      throw new MissingModuleIdException();
    }

    //if given type isn't a module throw exception
    else {
      throw new InvalidModuleException(_reflectedClass.simpleName);
    }
  }

  /**
   * Tries to invoke the init method of the the module.
   * In case the module doesn't contain a method marked
   * with the [@OnInit] annotation this method returns
   * false, otherwise it returns true
   */
  bool _tryInvokeOnInitHandler(ClassMirror classMirror, InstanceMirror instanceMirror, InitEventArgs args) {
    var initHandlerExists = false;

    classMirror.instanceMembers.forEach((methodName, methodMirror) {

      //check whether method is annotated
      if(!initHandlerExists
        && methodMirror.isRegularMethod
        && methodMirror.metadata.isNotEmpty) {

        //get onInit annotation
        var annotation = methodMirror.metadata.firstWhere(
          (meta) => meta.hasReflectee && meta.reflectee is OnInitAnnotation,
          orElse: () => null
        );

        //invoke onInit method if marked with onInit annotation
        if(annotation != null) {
          instanceMirror.invoke(methodName, [context, args]);
          initHandlerExists = true;
        }
      }
    });

    return initHandlerExists;
  }

  @override
  void onBeforeAdd() {
    _invokeOnBeforeAddHandler(_reflectedClass, _instance);
  }

  /**
   * Invokes all methods which are marked by the [@OnBeforeAdded] annotation.
   */
  void _invokeOnBeforeAddHandler(ClassMirror classMirror, InstanceMirror instanceMirror) {
    _invokeHandlerWhere(
      (meta) => meta.hasReflectee && meta.reflectee is OnBeforeAddAnnotation,
      classMirror, instanceMirror
    );
  }

  @override
  void onAdded() {
    _invokeOnAddedHandler(_reflectedClass, _instance);
  }

  /**
   * Invokes all methods which are marked by the [@OnAdded] annotation.
   */
  void _invokeOnAddedHandler(ClassMirror classMirror, InstanceMirror instanceMirror) {
    _invokeHandlerWhere(
        (meta) => meta.hasReflectee && meta.reflectee is OnAddedAnnotation,
        classMirror, instanceMirror
    );
  }

  @override
  void onBeforeRemove() {
    _invokeOnBeforeRemoveHandler(_reflectedClass, _instance);
  }

  /**
   * Invokes all methods which are marked by the [@OnBeforeRemove] annotation.
   */
  void _invokeOnBeforeRemoveHandler(ClassMirror classMirror, InstanceMirror instanceMirror) {
    _invokeHandlerWhere(
        (meta) => meta.hasReflectee && meta.reflectee is OnBeforeRemoveAnnotation,
        classMirror, instanceMirror
    );
  }

  @override
  void onRemoved() {
    _invokeOnRemovedHandler(_reflectedClass, _instance);
  }

  /**
   * Invokes all methods which are marked by the [@OnRemoved] annotation.
   */
  void _invokeOnRemovedHandler(ClassMirror classMirror, InstanceMirror instanceMirror) {
    _invokeHandlerWhere(
        (meta) => meta.hasReflectee && meta.reflectee is OnRemovedAnnotation,
        classMirror, instanceMirror
    );
  }

  @override
  void onRequestCompleted(RequestCompletedEventArgs args) {
    _invokeOnRequestCompletedHandler(_reflectedClass, _instance, args);
  }

  /**
   * Invokes all methods which are marked by the [@OnRequestCompleted] annotation.
   */
  void _invokeOnRequestCompletedHandler(ClassMirror classMirror, InstanceMirror instanceMirror, RequestCompletedEventArgs args) {
    _invokeHandlerWhere(
            (meta) => meta.hasReflectee
              && meta.reflectee is OnRequestCompleted
              && (
                  (meta.reflectee.requestId == args.requestId
                  && meta.reflectee.isErrorHandler == args.isErrorOccurred)
                  || meta.reflectee.isDefault
              ),
        classMirror, instanceMirror, args
    );
  }

  @override
  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    _invokeOnLoadingStateChangedHandler(_reflectedClass, _instance, args);
  }

  void _invokeOnLoadingStateChangedHandler(ClassMirror classMirror, InstanceMirror instanceMirror, LoadingStateChangedEventArgs args) {
    _invokeHandlerWhere(
      (meta) => meta.hasReflectee
        && meta.reflectee is OnLoadingStateChanged
        && (meta.reflectee.isLoading == args.isLoading || meta.reflectee.isDefault),
      classMirror, instanceMirror, args
    );
  }
}
