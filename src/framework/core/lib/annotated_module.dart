part of lib.core;

class AnnotatedModule extends AbstractModule {
  ClassMirror _reflectedClass;
  InstanceMirror _instance;
  final Type moduleType;

  AnnotatedModule.from(this.moduleType, String fragmentId, Map<String, dynamic> config)
    : super(fragmentId, config);

  @override
  void onInit(InitEventArgs args) {
    _reflectedClass = reflectClass(moduleType);
    var metadata = _reflectedClass.metadata;
    var annotation = metadata.firstWhere(
      (meta) => meta.hasReflectee && meta.reflectee is Module,
      orElse: () => null
    );

    //get new instance of module to invoke methods
    _instance = _reflectedClass.newInstance(const Symbol(''), []);

    //get module information for registration
    if(annotation != null) {

      //try to invoke onInit handler of module, if handler exists register module
      if(_tryInvokeOnInitHandler(_reflectedClass, _instance, args)) {
        //save module name
        _name = annotation.reflectee.name;
      }

      else {
        //TODO throw MissingOnInitMethodException -> can't register module
      }
    }

    //if given type isn't a module throw exception
    else {
      //TODO throw no module found exception
    }
  }

  /**
   * Tries to invoke the onInit method of the [instanceMirror] of the module.
   * In case the [classMirror] of the module doesn't contain a method marked
   * with the [@OnInit] annotation this method returns false, otherwise it returns true
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
          (meta) => meta.hasReflectee && meta.reflectee is _OnInit,
          orElse: () => null
        );

        //invoke onInit method if marked with onInit annotation
        if(annotation != null) {
          instanceMirror.invoke(methodName, [args]);
          initHandlerExists = true;
        }
      }
    });

    return initHandlerExists;
  }

  @override
  void onBeforeAdd(NavigationEventArgs args) {

  }

  @override
  void onRequestCompleted(RequestCompletedEventArgs args) {
    _invokeOnRequestCompletedHandler(_reflectedClass, _instance, args);
  }

  /**
   * Invokes all methods which are marked by the [@OnRequestCompleted] annotation.
   */
  void _invokeOnRequestCompletedHandler(ClassMirror classMirror, InstanceMirror instanceMirror, RequestCompletedEventArgs args) {
    classMirror.instanceMembers.forEach((Symbol methodName, MethodMirror methodMirror) {

      //check whether method is annotated
      if(methodMirror.isRegularMethod
        && methodMirror.metadata.isNotEmpty) {

        //get all methods to invoke
        var annotations = methodMirror.metadata.where(
                (meta) => meta.hasReflectee
                            && meta.reflectee is OnRequestCompleted
                            && (
                              (meta.reflectee.requestId == args.requestId
                                && meta.reflectee.isErrorHandler == args.isErrorOccurred)
                              || meta.reflectee.isDefault
                            )
        );

        //invoke onInit method
        if(annotations.isNotEmpty) {
          instanceMirror.invoke(methodName, [args]);
        }
      }
    });
  }
}
