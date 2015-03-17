part of modularity.core;

/// Representation of a page
class Page {
  static const String namespace = "modularity.core.Page";
  NavigationParameter _navigationParameter;
  ApplicationContext _context;
  ViewTemplate _template;

  final List<Fragment> fragments;
  final utility.Logger logger;
  final String title;
  final String uri;

  /// Initializes the page with its [uri] and [title]. The title is usually used by navigation modules
  /// to create menu entries automatically
  Page(this.uri, this.title, {ViewTemplate template, this.logger}) : fragments = new List<Fragment>() {
    //load default template
    if (template == null) {
      //template = new DefaultPageTemplate(logger: logger); //TODO create default template
    }

    _template = template;
  }

  /**
   * Sets the application context
   */
  void set context(ApplicationContext context) {
    _context = context;
    _context.page = this;
  }

  /**
   * Gets the application context
   */
  ApplicationContext get context {
    return _context;
  }

  /// Gets the template of this page
  ViewTemplate get template => _template;

  /**
   * Adds this page to the DOM
   */
  void open(NavigationEventArgs args) {
    _navigationParameter = args.parameter;

    for (var fragment in fragments) {
      fragment.addToDOM(args);
    }
  }

  /**
   * Removes this page from DOM
   */
  void close() {
    for (var fragment in fragments) {
      fragment.removeFromDOM();
    }
  }

  /// adds a [Fragment] to this page
  void addFragment(Fragment fragment) {
    if(!fragments.contains(fragment)) {
      fragment.context = context;
      fragments.add(fragment);
    }

    else if(logger != null) {
      logger.log(new FragmentExistsWarning(namespace, uri, fragment.id));
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
      logger.log(new MissingParameterWarning(namespace, uri, name));
    }

    return result;
  }
}
