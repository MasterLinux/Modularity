part of modularity.core;

class ModuleCallbackInvocationEventArgs extends EventArgs {
  //TODO implement
}

/**
 * Helper class to load and handle annotated
 * modules. This class is used to load
 * modules with the help of its library
 * and class name.
 */
class Module implements TemplateController { //TODO rename to View
  final Map<String, Object> config;
  final Logger logger;
  final String name;
  final String lib;

  JsonTemplate _template;
  ApplicationContext _context;
  ClassMirror _reflectedClass;
  InstanceMirror _instance;

  annotations.ApplicationModule _meta;
  String _id;

  /**
   * Gets or sets the application context
   */
  ApplicationContext context;

  /**
   * Gets the unique ID of the module.
   * Each instance of a module has
   * its own unique ID.
   */
  String get id {
    return _id;
  }

  /**
   * Gets the meta information
   * of this module.
   */
  annotations.ApplicationModule get meta {
    return _meta;
  }

  /**
   * Gets the template of the module
   */
  JsonTemplate get template => _template;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "module";

  /**
   * Initializes the module with the help
   * of a class which uses module annotations.
   */
  Module(this.lib, this.name, Map template, this.config, {this.logger}) {
    _id = new UniqueId(ID_PREFIX).build();
    _template = new JsonTemplate(template, _id, this, logger: logger);
    onInit(new InitEventArgs(this.config));
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add(NavigationEventArgs args) {
    onBeforeAdd(args);
    template.render(context.fragment.id);
    onAdded(args);
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove() {
    onBeforeRemove();
    template.destroy();
    onRemoved();
  }

  @override
  void invokeCallback(String callbackName, Map<String, String> parameter) {
    var args = new ModuleCallbackInvocationEventArgs();

    _invokeHandlerWhere(
            (methodName, meta) {
              return methodName == new Symbol(callbackName) && meta.hasReflectee &&
                meta.reflectee is annotations.TemplateCallback;
            },
            _reflectedClass, _instance, args
    ); //TODO return false if not found
  }

  @override
  Property getProperty(String name) {
    //TODO implement
    return null;
  }

  /**
   * Invokes all event handler which are passed the given [test].
   */
  void _invokeHandlerWhere(bool test(Symbol methodName, InstanceMirror mirror), ClassMirror classMirror, InstanceMirror instanceMirror, [EventArgs args]) {
    classMirror.instanceMembers.forEach((Symbol methodName, MethodMirror methodMirror) {

      //check whether method is annotated
      if(methodMirror.isRegularMethod
        && methodMirror.metadata.isNotEmpty) {

        //get all methods to invoke
        var annotations = methodMirror.metadata.where((meta) {
          return test(methodName, meta);
        });

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
    _reflectedClass = classUtil.getClassMirror(lib, name);

    var metadata = _reflectedClass.metadata;
    var annotation = metadata.firstWhere(
      (meta) => meta.hasReflectee && meta.reflectee is annotations.ApplicationModule,
      orElse: () => null
    );

    //get new instance of module to invoke methods
    _instance = _reflectedClass.newInstance(const Symbol(''), []);

    //get module information for registration
    if(annotation != null && name != null) {
      _meta = annotation.reflectee as annotations.ApplicationModule;

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
          (meta) {
            return meta.hasReflectee && meta.reflectee is annotations.OnInitAnnotation;
          },
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
  void onBeforeAdd(NavigationEventArgs args) {
    _invokeHandlerWhere(
            (methodName, meta) {
              return meta.hasReflectee && meta.reflectee is annotations.OnBeforeAddAnnotation;
            },
            _reflectedClass, _instance, args
    );
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded(NavigationEventArgs args) {
    _invokeHandlerWhere(
            (methodName, meta) {
              return meta.hasReflectee && meta.reflectee is annotations.OnAddedAnnotation;
            },
            _reflectedClass, _instance, args
    );
  }

  /**
   * This event handler is invoked when the module
   * will be destroyed but before the template
   * is removed from DOM.
   */
  void onBeforeRemove() {
    _invokeHandlerWhere(
            (methodName, meta) {
              return meta.hasReflectee && meta.reflectee is annotations.OnBeforeRemoveAnnotation;
            },
            _reflectedClass, _instance
    );
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved() {
    _invokeHandlerWhere(
        (methodName, meta) {
          return meta.hasReflectee && meta.reflectee is annotations.OnRemovedAnnotation;
        },
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
            (methodName, meta) {
              return meta.hasReflectee
                && meta.reflectee is annotations.OnRequestCompleted
                && (
                    (meta.reflectee.requestId == args.requestId
                    && meta.reflectee.isErrorHandler == args.isErrorOccurred)
                    || meta.reflectee.isDefault
                );
            },
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
      (methodName, meta) {
        return meta.hasReflectee
          && meta.reflectee is annotations.OnLoadingStateChanged
          && (meta.reflectee.isLoading == args.isLoading || meta.reflectee.isDefault);
      },
      _reflectedClass, _instance, args
    );
  }

}
