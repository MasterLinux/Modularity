part of modularity.core;

class Fragment {
  static const String namespace = "modularity.core.Fragment";
  String _id;

  final List<Module> modules = new List<Module>();
  final ApplicationContext context;  //TODO redefine application context
  final Page page; //TODO use for communication?

  /**
   * The ID of the fragment which is identical to
   * its specific page template node in which
   * the fragment is placed
   */
  String get id => _id;

  utility.Logger get logger => context.logger;

  /**
   * Initializes the fragment with its ID.
   */
  Fragment(String id, this.page, this.context) {
    _id = id != null ? id : page.id;
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
  Future addToDOM(NavigationEventArgs args) async {
    for(var module in modules) {
      await module.add(args);
    }
  }

  /**
   * Remove the fragment and all its
   * modules from DOM.
   */
  Future removeFromDOM() async {
    for(var module in modules) {
      await module.remove();
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

/// Warning which is used whenever a fragment is already added
class FragmentExistsWarning extends utility.WarningMessage {
  final String _uri;
  final String _id;

  FragmentExistsWarning(String namespace, String pageUri, String fragmentId) : _id = fragmentId, _uri = pageUri, super(namespace);

  @override
  String get message =>
  "Fragment with ID => \"$_id\" is already added to page with URI => \"$_uri\". You have to fix the duplicate to ensure that the application works as expected.";
}
