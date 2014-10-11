part of modularity.core;

/**
 *
 */
class Page {
  Map<String, dynamic> _navigationParameter;
  final List<ConfigFragmentModel> fragments; //TODO find solution for adding fragments
  final String title;
  final String uri;

  Page(this.uri, this.title);

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

  /**
   * Gets a specific navigation parameter by its [name].
   * Whenever the parameter with the given name doesn't
   * exists it throws a [MissingNavigationParameterException].
   */
  dynamic getNavigationParameter(String name) { //TODO do not use dynamic
    //try to get navigation parameter
    if(name != null
        && _navigationParameter != null
        && _navigationParameter.containsKey(name)) {

      return _navigationParameter[name];
    }

    //if the required parameter isn't available throw exception
    else {
      throw new MissingNavigationParameterException(name);
    }
  }

  //TODO page injector required to inject specific page behaviour?
}
