part of modularity.core;

class Navigator {
  static const String namespace = "modularity.core.Navigator";
  final List<NavigationListener> _listener;
  final List<HistoryItem> _history;
  Page _currentPage;
  Logger logger;

  /**
   * Gets all pages if no page is loaded
   * it returns an empty list
   */
  final HashMap<String, Page> pages;

  Navigator() :
    pages = new HashMap<String, Page>(),
    _listener = new List<NavigationListener>(),
    _history = new List<HistoryItem>();

  void navigateTo(Uri uri, {NavigationParameter parameter}) {
    if(pages.containsKey(uri)) {
      var args = new NavigationEventArgs(uri, parameter: parameter);
      //TODO implement hash change
      if(_currentPage) {
        _currentPage.close();
      }

      _currentPage = pages[uri];
      _currentPage.open(args);

      for(var listener in _listener) {
        listener.onNavigatedTo(this, _currentPage, args);
      }

      _history.add(uri);
    } else if(logger != null) {
      logger.log(new MissingPageWarning(namespace, uri));
    }
  }

  void navigateBack() {
    //remove current page from history
    _history.removeLast();

    if(_history.isNotEmpty) {
      var uri = _history.last;
      //TODO implement back navigation

      for(var listener in _listener) {
        var args = new NavigationEventArgs(uri, isNavigatedBack: true);  //TODO get previous navigation parameter
        listener.onNavigatedTo(this, _currentPage, args);
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

  Page get currentPage {
    return _currentPage;
  }

  /**
   * Adds all [pages] in list to the application
   */
  void addPages(List<Page> pagesCollection) {
    pages.addAll(new HashMap.fromIterable(pagesCollection, key: (page) {
      if(logger != null && pages.containsKey(page.uri)) {
        logger.log(new PageExistsWarning(namespace, page.uri));
      }

      return page.uri;
    }));
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    if(logger != null && pages.containsKey(page.uri)) {
      logger.log(new PageExistsWarning(namespace, page.uri));
    }

    pages[page.uri] = page;
  }
}

class NavigationListener {
  void onNavigatedTo(Navigator sender, Page page, NavigationEventArgs args);
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
    this.isNavigatedBack: false,
    this.parameter
  });
}

