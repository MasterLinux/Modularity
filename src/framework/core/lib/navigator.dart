part of modularity.core;

class Navigator {
  final List<NavigationListener> _listener;
  Logger logger;

  Navigator() :
    _listener = new List<NavigationListener>();

  void navigateTo(Uri uri) {
    //TODO implement navigation

    for(var listener in _listener) {
      var args = new NavigationEventArgs();

      listener.onNavigatedTo(this, args);
    }
  }

  void navigateBack() {
    //TODO implement back navigation

    for(var listener in _listener) {
      var args = new NavigationEventArgs(isNavigatedBack: true);

      listener.onNavigatedBack(this, args);
    }
  }

  void addListener(NavigationListener listener) => _listener.add(listener);

  void removeListener(NavigationListener listener) => _listener.remove(listener);

  void cleanUp() {
    _listener.clear();
    logger = null;
  }
}

class NavigationListener {
  void onNavigatedBack(Navigator sender, NavigationEventArgs args);
  void onNavigatedTo(Navigator sender, NavigationEventArgs args);
}
