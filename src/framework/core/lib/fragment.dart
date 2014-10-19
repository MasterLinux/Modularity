part of modularity.core;

class Fragment {
  List<AnnotatedModule> _modules;
  String _title;
  String _id;

  /**
   * Prefix used for the node ID.
   */
  final String ID_PREFIX = "fragment";

  /**
   * Gets the parent page of the fragment.
   */
  Page _page;

  /**
   * Gets the title of the fragment.
   */
  final String title;

  /**
   * Initializes the fragment.
   */
  Fragment(this.title, modules) {
    _id = new UniqueId(ID_PREFIX).build();
    _loadModules(modules);
  }

  /**
   * Gets the unique ID of the fragment.
   * This ID is used as node ID.
   */
  String get id => _id;

  /// registers the parent [page]
  void register(Page page) {
    _page = page;
  }

  /**
   * Loads all modules with the help
   * of the config.
   */
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
  }

  /**
   * Adds the fragment and all its
   * modules to DOM.
   */
  void add() {
    //TODO add fragment template

    for(var module in _modules) {
      module.add();
    }
  }

  /**
   * Remove the fragment and all its
   * modules from DOM.
   */
  void remove() {
    for(var module in _modules) {
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

    for(var module in _modules) {
      module.onRequestCompleted(args);
    }
  }

  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    //TODO allow to catch this event to manipulate fragment

    for(var module in _modules) {
      module.onLoadingStateChanged(args);
    }
  }
}
