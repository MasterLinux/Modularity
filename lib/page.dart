part of modularity.core;

/// Representation of a page
class Page {
  static const String namespace = "modularity.core.Page";
  NavigationParameter _navigationParameter;
  ApplicationContext context;
  View _view;

  final List<Fragment> fragments;
  final NavigationUri uri;
  final String title;
  final String rootId;

  /// Initializes the page with its [uri] and [title]. The title is usually used by navigation modules
  /// to create menu entries automatically
  Page(this.rootId, this.uri, this.title, this.context, {View view}) : fragments = new List<Fragment>() {
    //load default view
    if (view == null) {
      view = new ContentView();
    }

    _view = view;
  }

  /// Gets the view of this page
  View get view => _view;

  /// Gets the ID of the page view
  String get id => view.id;

  Application get application => context.application; //TODO remove

  utility.Logger get logger => context.logger;

  /**
   * Adds this page to the DOM
   */
  Future open(NavigationEventArgs args) async {
    _navigationParameter = args.parameter;

    //TODO create view tree than add?
    await view.addToDOM(rootId);

    for (var fragment in fragments) {
      await fragment.addToDOM(args);
    }
  }

  /**
   * Removes this page from DOM
   */
  Future close() async {
    for (var fragment in fragments) {
      await fragment.removeFromDOM();
    }

    await view.removeFromDOM();
  }

  /// adds a [Fragment] to this page
  void addFragment(Fragment fragment) {
    if(!fragments.contains(fragment)) {
      fragments.add(fragment);
    }

    else if(logger != null) {
      logger.log(new FragmentExistsWarning(namespace, uri.toString(), fragment.id));
    }
  }

  /// adds a collection of [Fragment]s to this page
  void addFragments(List<Fragment> fragments) {
    for(var fragment in fragments) {
      addFragment(fragment);
    }
  }

  /**
   * Gets a specific navigation parameter by its [name].
   * Whenever the parameter with the given name doesn't
   * exists it returns null.
   */
  Object getNavigationParameter(String name) {
    var result = null;

    //try to get navigation parameter
    if(name != null
        && _navigationParameter != null
        && _navigationParameter.contains(name)) {

      result = _navigationParameter[name];
    }

    //log if the required parameter isn't available
    else if(logger != null) {
      logger.log(new MissingParameterWarning(namespace, uri.toString(), name));
    }

    return result;
  }
}

/**
 * Warning which is used whenever a page already exists
 */
class PageExistsWarning extends utility.WarningMessage {
  final String _uri;

  PageExistsWarning(String namespace, String uri) : _uri = uri, super(namespace);

  @override
  String get message =>
  "Page with URI => \"$_uri\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}

class MissingPageWarning extends utility.WarningMessage {
  final String _uri;

  MissingPageWarning(String namespace, String uri) : _uri = uri, super(namespace);

  @override
  String get message =>
  "Page with URI => \"$_uri\" does not exists. Please check whether a page with this URI is registered.";
}
