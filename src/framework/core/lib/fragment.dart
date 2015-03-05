part of modularity.core;

class Fragment {
  static const String namespace = "modularity.core.Fragment";
  List<Module> modules;
  ApplicationContext _context;
  final Logger logger;

  /**
   * The ID of the fragment which is identical to
   * its specific page template node in which
   * the fragment is placed
   */
  final String id;

  /**
   * Initializes the fragment with its ID.
   */
  Fragment(this.id, {this.logger});

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

  /// adds a collection of [AnnotatedModule]s to the fragment
  void addModules(List<Module> modules) {
    for(var module in modules) {
      addModule(module);
    }
  }

  /**
   * Adds a module to the fragment
   */
  void addModule(Module module) {
    if(!modules.contains(module)) {
      module.context = context;
      modules.add(module);
    }

    else if(logger != null) {
      logger.log(new ModuleExistsWarning(namespace, module.id, id));
    }
  }

  /**
   * Adds all its modules of the fragment to
   * the DOM. The [args.isNavigatedBack]
   * flag indicates whether this fragment is
   * re-added 'caused by a back navigation
   */
  void addToDOM(NavigationEventArgs args) {
    for(var module in modules) {
      module.add(args);
    }
  }

  /**
   * Remove the fragment and all its
   * modules from DOM.
   */
  void removeFromDOM() {
    for(var module in modules) {
      module.remove();
    }
  }

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args) {
    for(var module in modules) {
      module.onRequestCompleted(args);
    }
  }

  /**
   * This event handler is invoked whenever the loading state
   * is changed.
   */
  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    for(var module in modules) {
      module.onLoadingStateChanged(args);
    }
  }
}
