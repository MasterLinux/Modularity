part of lib.core;

class Page {
  Map<String, dynamic> _navigationParameter;
  final List<ConfigPageModel> pages;
  final String title;

  Page(this.title, this.pages);

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
}
