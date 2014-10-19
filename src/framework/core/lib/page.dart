part of modularity.core;

typedef Template PageTemplateFactory();

PageTemplateFactory _defaultPageTemplate() => null;

/**
 *
 */
class Page {
  static const String namespace = "modularity.core.Page";
  NavigationParameter _navigationParameter;
  final PageTemplateFactory template;
  final List<Fragment> fragments;
  final Logger logger;
  final String title;
  final String uri;

  Page(this.uri, this.title, {this.template: _defaultPageTemplate, this.logger}) : fragments = new List<Fragment>();

  /**
   * Adds this page to the DOM
   */
  void open(NavigationEventArgs args) {

  }

  /**
   * Removes this page from DOM
   */
  void close() {

  }

  void addFragment(Fragment fragment) => fragments.add(fragment);

  void addFragments(List<Fragment> fragments) => this.fragments.addAll(fragments);

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
