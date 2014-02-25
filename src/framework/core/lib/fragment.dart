part of lib.core;

class Fragment {
  List<AbstractModule> _modules;
  String _id;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "fragment";

  /**
   * Initializes the fragment.
   */
  Fragment() {
    _id = new UniqueId(ID_PREFIX).build();
    _modules = [];
  }

  /**
   * Gets the unique ID of the fragment.
   * This ID is used as node ID.
   */
  String get id => _id;

  /**
   * Loads all modules with the help
   * of the config.
   */
  void _loadModules(List<ConfigModuleModel> modules) {

    //creates all modules of this fragment
    for(var model in modules) {
      _modules.add(
          new AnnotatedModule(
            model.libraryName,
            model.moduleName,
            _id,
            model.config
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
