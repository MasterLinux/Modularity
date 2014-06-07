part of lib.core;

/**
 * Helper class to load and handle annotated
 * modules. This class is used to load
 * modules with the help of its library
 * and class name.
 */
class AnnotatedModule {
  final Map<String, Object> config;
  final Fragment fragment;
  final String name;
  final String lib;

  ClassMirror _reflectedClass;
  InstanceMirror _instance;
  ModuleContext _context;

  String _uniqueId;
  Module _meta;

  /**
   * Gets the unique ID of the module.
   * Each instance of a module has
   * its own unique ID.
   */
  String get uniqueId {
    return _uniqueId;
  }

  /**
   * Gets the module context, used
   * to get the current displayed
   * page and to communicate with
   * other modules.
   */
  ModuleContext get context {
    return _context;
  }

  /**
   * Gets the meta information
   * of this module.
   */
  Module get meta {
    return _meta;
  }

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "module";

  /**
   * Initializes the module with the help
   * of a class which uses the module annotations.
   */
  AnnotatedModule(this.lib, this.name, this.fragment, this.config) {
    _uniqueId = new UniqueId(ID_PREFIX).build();
    _context = new ModuleContext(this);

    onInit(new InitEventArgs(this.config));
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add() {
    onBeforeAdd();

    //TODO add template to DOM

    onAdded();
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove() {
    onBeforeRemove();

    //TODO remove template from DOM

    onRemoved();
  }

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
   * This init function is called once when the module
   * is initialized on app start.
   */
  void onInit(InitEventArgs args) {
    _reflectedClass = getClassMirror(lib, name);

    var metadata = _reflectedClass.metadata;
    var annotation = metadata.firstWhere(
      (meta) => meta.hasReflectee && meta.reflectee is Module,
      orElse: () => null
    );

    //get new instance of module to invoke methods
    _instance = _reflectedClass.newInstance(const Symbol(''), []);

    //get module information for registration
    if(annotation != null && name != null) {
      _meta = annotation.reflectee as Module;

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

  /**
   * This event handler is invoked when the module will be created,
   * but before the template of the module is added to the DOM.
   */
  void onBeforeAdd() {
    _invokeHandlerWhere(
            (meta) => meta.hasReflectee && meta.reflectee is OnBeforeAddAnnotation,
            _reflectedClass, _instance
    );
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded() {
    _invokeHandlerWhere(
            (meta) => meta.hasReflectee && meta.reflectee is OnAddedAnnotation,
            _reflectedClass, _instance
    );
  }

  /**
   * This event handler is invoked when the module
   * will be destroyed but before the template
   * is removed from DOM.
   */
  void onBeforeRemove() {
    _invokeHandlerWhere(
            (meta) => meta.hasReflectee && meta.reflectee is OnBeforeRemoveAnnotation,
            _reflectedClass, _instance
    );
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved() {
    _invokeHandlerWhere(
        (meta) => meta.hasReflectee && meta.reflectee is OnRemovedAnnotation,
        _reflectedClass, _instance
    );
  }

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args) {
    _invokeHandlerWhere(
            (meta) => meta.hasReflectee
              && meta.reflectee is OnRequestCompleted
              && (
                  (meta.reflectee.requestId == args.requestId
                  && meta.reflectee.isErrorHandler == args.isErrorOccurred)
                  || meta.reflectee.isDefault
              ),
            _reflectedClass, _instance, args
    );
  }

  /**
   * This event handler is invoked whenever the loading state is
   * changed. For example if the module starts to load
   * data or receives data.
   */
  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    _invokeHandlerWhere(
      (meta) => meta.hasReflectee
        && meta.reflectee is OnLoadingStateChanged
        && (meta.reflectee.isLoading == args.isLoading || meta.reflectee.isDefault),
      _reflectedClass, _instance, args
    );
  }

}
