part of modularity.core;

class Navigator {
  final List<NavigationListener> _listener;
  List<HistoryItem> _history;
  Logger logger;

  Navigator() :
    _listener = new List<NavigationListener>();

  void navigateTo(Uri uri, {NavigationParameter parameter}) {
    //TODO implement navigation

    for(var listener in _listener) {
      var args = new NavigationEventArgs(uri, parameter: parameter);
      listener.onNavigatedTo(this, args);
    }

    _history.add(uri);
  }

  void navigateBack() {
    //remove current page from history
    _history.removeLast();

    if(_history.isNotEmpty) {
      var uri = _history.last;
      //TODO implement back navigation

      for(var listener in _listener) {
        var args = new NavigationEventArgs(uri, isNavigatedBack: true);  //TODO get previous navigation parameter
        listener.onNavigatedTo(this, args);
      }
    }
  }

  void addListener(NavigationListener listener) => _listener.add(listener);

  void removeListener(NavigationListener listener) => _listener.remove(listener);

  /**
   * Removes all listener and
   * history entries
   */
  void clear() {
    _listener.clear();
    _history.clear();
    logger = null;
  }
}

class NavigationListener {
  void onNavigatedTo(Navigator sender, NavigationEventArgs args);
}

class HistoryItem {
  String previousPageUri;
  String pageUri;
}

class NavigationParameter {
  final HashMap<String, Object> _parameter;

  NavigationParameter.fromMap(Map<String, Object> parameter) : _parameter = parameter;

  NavigationParameter() : _parameter = new HashMap<String, Object>();

  void add(String key, Object value) {

  }


}

class NavigationEventArgs implements EventArgs {
  final NavigationParameter parameter; //TODO do not use dynamic
  final bool isNavigatedBack;
  final String uri;

  NavigationEventArgs(this.uri, {
    this.parameter: new NavigationParameter(),
    this.isNavigatedBack: false
  });
}

