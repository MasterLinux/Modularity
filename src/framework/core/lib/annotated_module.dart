part of lib.core;

class AnnotatedModule extends AbstractModule {
  ClassMirror _reflectedClass;
  InstanceMirror _instance;
  final Type moduleType;

  AnnotatedModule.from(this.moduleType, String fragmentId, Map<String, dynamic> config)
    : super(fragmentId, config);

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
    if(annotation != null && (_name = annotation.reflectee.name) != null) {

      //try to invoke onInit handler of module, if handler doesn't exists throw exception
      if(!_tryInvokeOnInitHandler(_reflectedClass, _instance, args)) {
        throw new MissingInitMethodException(_name);
      }
    }

    //if name is missing throw exception
    else if(annotation != null && _name == null) {
      throw new MissingModuleNameException();
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
          (meta) => meta.hasReflectee && meta.reflectee is _OnInit,
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
  void onBeforeAdd(NavigationEventArgs args) {
    _invokeOnBeforeAddHandler(_reflectedClass, _instance, args);
  }

  /**
   * Invokes all methods which are marked by the [@OnBeforeAdded] annotation.
   */
  void _invokeOnBeforeAddHandler(ClassMirror classMirror, InstanceMirror instanceMirror, NavigationEventArgs args) {
    _invokeHandlerWhere(
      (InstanceMirror meta) => meta.hasReflectee && meta.reflectee is _OnBeforeAdd,
      classMirror, instanceMirror, args
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
        (InstanceMirror meta) => meta.hasReflectee && meta.reflectee is _OnAdded,
        classMirror, instanceMirror
    );
  }

  @override
  void onBeforeRemove(NavigationEventArgs args) {
    _invokeOnBeforeRemoveHandler(_reflectedClass, _instance, args);
  }

  /**
   * Invokes all methods which are marked by the [@OnBeforeRemove] annotation.
   */
  void _invokeOnBeforeRemoveHandler(ClassMirror classMirror, InstanceMirror instanceMirror, NavigationEventArgs args) {
    _invokeHandlerWhere(
        (InstanceMirror meta) => meta.hasReflectee && meta.reflectee is _OnBeforeRemove,
        classMirror, instanceMirror, args
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
        (InstanceMirror meta) => meta.hasReflectee && meta.reflectee is _OnRemoved,
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
            (InstanceMirror meta) => meta.hasReflectee
              && meta.reflectee is OnRequestCompleted
              && (
                  (meta.reflectee.requestId == args.requestId
                  && meta.reflectee.isErrorHandler == args.isErrorOccurred)
                  || meta.reflectee.isDefault
              ),
        classMirror, instanceMirror, args
    );
  }
}
