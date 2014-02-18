part of lib.core;

class AnnotatedModule extends Module {
  InstanceMirror _instance;
  final Type moduleDefinition;

  AnnotatedModule.from(this.moduleDefinition, String fragmentId, Map<String, dynamic> config)
    : super(fragmentId, config);

  @override
  void onInit(InitEventArgs args) {
    var classMirror = reflectClass(moduleDefinition);
    var metadata = classMirror.metadata;
    var annotation = metadata.first.reflectee;

    //get new instance of module to invoke methods
    _instance = classMirror.newInstance(const Symbol(''), []);

    //get module information for registration
    if(annotation is module) {

      //try to invoke onInit handler of module, if handler exists register module
      if(tryInvokeOnInitHandler(classMirror, _instance, args)) {
        register(annotation.namespace, annotation.name);
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
   * with the [@onInit] annotation this method returns false, otherwise it returns true
   */
  bool tryInvokeOnInitHandler(ClassMirror classMirror, InstanceMirror instanceMirror, InitEventArgs args) {
    classMirror.instanceMembers.forEach((methodName, methodMirror) {

      //check whether method is annotated
      if(methodMirror.metadata.length > 0) {
        var annotation = methodMirror.metadata.first.reflectee;

        //invoke onInit method
        if(annotation is _OnInit) {
          instanceMirror.invoke(methodName, [args]);
          return true;
        }
      }
    });

    return false;
  }
}
