part of modularity.core;

/**
 *
 */
class Page {
  Map<String, dynamic> _navigationParameter;
  final List<ConfigFragmentModel> fragments;
  final String title;
  final String uri;

  Page(this.title, this.uri, this.fragments);

  void navigate() {

  }

  void onNavigatedTo(NavigationEventArgs args) {

  }

  void onNavigatedBack(NavigationEventArgs args) {

  }

  /**
   * Gets a specific navigation parameter by its [name].
   * Whenever the parameter with the given name doesn't
   * exists it throws a [MissingNavigationParameterException].
   */
  dynamic getNavigationParameter(String name) {
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
