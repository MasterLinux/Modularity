part of modularity.core;

class Fragment {
  static const String namespace = "modularity.core.Fragment";
  List<AnnotatedModule> modules;
  ApplicationContext _context;
  Logger logger;  //TODO replace with a singleton pattern

  /**
   * The ID of the fragment which is identical to
   * its specific page template node in which
   * the fragment is placed
   */
  final String id;

  /**
   * Initializes the fragment with its ID.
   */
  Fragment(this.id);

  /**
   * Sets the application context
   */
  void set context(ApplicationContext context) {
    _context = context;
    _context.fragment = this;
  }

  /**
   * Gets the application context
   */
  ApplicationContext get context {
    return _context;
  }

  /**
   * Adds a module to the fragment
   */
  void addModule(AnnotatedModule module) {
    if(!modules.contains(module)) {
      module.context = context;
      modules.add(module);
    }

    else if(logger != null) {
      logger.log(new ModuleExistsWarning(namespace, module.id, id));
    }
  }

  /**
   * Loads all modules with the help
   * of the config.
   */
  /*
  void _loadModules(ConfigModulesModel modulesConfig) {
    _modules = [];

    //creates all modules of this fragment
    for(var module in modulesConfig.objects) {
      _modules.add(
          new AnnotatedModule(
            module.lib,
            module.name,
            this,
            module.config
          )
      );
    }
  } */

  /**
   * Adds all its modules of the fragment to
   * the DOM. The [isNavigatedBack]
   * flag indicates whether this fragment is
   * re-added 'caused by a back navigation
   */
  void add(bool isNavigatedBack) {
    //TODO add fragment template

    for(var module in modules) {
      module.add();
    }
  }

  /**
   * Remove the fragment and all its
   * modules from DOM.
   */
  void remove() {
    for(var module in modules) {
      module.remove();
    }

    //TODO remove fragment template
  }

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args) {
    //TODO allow to catch this event to manipulate fragment -> via config? or via callback?

    for(var module in modules) {
      module.onRequestCompleted(args);
    }
  }

  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    //TODO allow to catch this event to manipulate fragment

    for(var module in modules) {
      module.onLoadingStateChanged(args);
    }
  }
}
