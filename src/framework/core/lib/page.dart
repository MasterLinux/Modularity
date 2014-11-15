part of modularity.core;

/**
 *
 */
class Page {
  static const String namespace = "modularity.core.Page";
  NavigationParameter _navigationParameter;
  PageTemplate _template;

  final List<Fragment> fragments;
  final Logger logger;
  final String title;
  final String uri;

  Page(this.uri, this.title, {PageTemplate template, this.logger}) : fragments = new List<Fragment>() {
    //load default template
    if (template == null) {
      template = new DefaultPageTemplate(logger: logger);
    }

    _template = template;
  }

  /// Gets the template of this page
  PageTemplate get template => _template;

  /**
   * Adds this page to the DOM
   */
  void open(NavigationEventArgs args) {
    for (var fragment in fragments) {
      fragment.add();
    }
  }

  /**
   * Removes this page from DOM
   */
  void close() {
    for (var fragment in fragments) {
      fragment.remove();
    }
  }

  /// adds a [Fragment] to this page
  void addFragment(Fragment fragment) {
    if(!fragments.contains(fragment)) {
      fragment.register(this);
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
      logger.log(new MissingNavigationParameterWarning(namespace, uri, name));
    }

    return result;
  }

  //TODO page injector required to inject specific page behaviour?
}
