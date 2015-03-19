part of modularity.core;

typedef NavigationStrategy NavigationStrategyFactory();

NavigationStrategy _defaultNavigationStrategy() => new DefaultNavigationStrategy();

class Navigator {
  static const String namespace = "modularity.core.Navigator";
  static const String idPrefix = "navigation";

  final HashMap<String, NavigationParameter> _parameterCache;
  final List<NavigationListener> _listener;
  final NavigationStrategyFactory strategy;
  final List<HistoryItem> _history;
  final Router _router;
  Page _currentPage;
  utility.Logger logger;

  /**
   * Gets all pages if no page is loaded
   * it returns an empty list
   */
  final HashMap<String, Page> pages;

  /// initializes the navigator with a specific [NavigationStrategy]
  /// if no [strategy] is set the default strategy is used
  Navigator({this.strategy: _defaultNavigationStrategy}) :
    pages = new HashMap<String, Page>(),
    _parameterCache = new HashMap<String, NavigationParameter>(),
    _listener = new List<NavigationListener>(),
    _history = new List<HistoryItem>(),
    _router = new Router()
  {
    _router.root
        ..addRoute(name: 'page', path: '/page/:uri/:id', enter: _openPage);

    _router.listen();
  }

  void _cacheNavigationParameter(String uri, String navigationId, NavigationParameter parameter) {
      var key = "${uri}_${navigationId}";
      _parameterCache[key] = parameter;
  }

  NavigationParameter _getCachedNavigationParameter(String uri, String navigationId) {
      var key = "${uri}_${navigationId}";
      return _parameterCache[key];
  }

  void _openPage(RouteEvent e) {
    var uri = e.parameters['uri'];
    var navigationId = e.parameters['id'];

    if(pages.containsKey(uri)) {
      var parameter = _getCachedNavigationParameter(uri, navigationId);
      var args = new NavigationEventArgs(uri, parameter: parameter);
      var historyItem = new HistoryItem()
        ..id = navigationId
        ..uri = uri;

      if(_currentPage != null) {
        _currentPage.close();
      }

      _currentPage = pages[uri];
      _currentPage.open(args);
      _history.add(historyItem);

      for(var listener in _listener) {
        listener.onNavigatedTo(this, _currentPage, args);
      }
    }

    else if(logger != null) {
      logger.log(new MissingPageWarning(namespace, uri));
    }
  }

  /// opens a specific [Page] with the help of its [uri]
  Future navigateTo(String uri, {NavigationParameter parameter}) {
    if(pages.containsKey(uri)) {
      var args = new NavigationEventArgs(uri, parameter: parameter);
      var navigationId = new utility.UniqueId(idPrefix).build();
      var navigationStrategy = strategy();

      _cacheNavigationParameter(uri, navigationId, parameter);

      return _router.go('page', {'uri': uri, 'id': navigationId},
          replace: navigationStrategy.shouldReplace(pages[uri], _currentPage)
      );
    }

    else if(logger != null) {
      logger.log(new MissingPageWarning(namespace, uri));
    }

    //TODO return future
  }

  /// opens the previous [Page]
  Future navigateBack() {
    //remove current page from history
    _history.removeLast();

    if(_history.isNotEmpty) {
      var historyItem = _history.last;
      var parameter = _getCachedNavigationParameter(historyItem.uri, historyItem.id);

      //TODO implement back navigation

      for(var listener in _listener) {
        var args = new NavigationEventArgs(historyItem.uri, parameter: parameter, isNavigatedBack: true);
        listener.onNavigatedTo(this, _currentPage, args);
      }
    }

    //TODO return future
  }

  /// adds a new [listener] which listen to page changes
  void addListener(NavigationListener listener) => _listener.add(listener);

  /// removes a specific [listener]
  bool removeListener(NavigationListener listener) => _listener.remove(listener);

  /// cleans up the navigator
  void clear() {
    if(_currentPage != null) {
      _currentPage.close();
      _currentPage = null;
    }

    _listener.clear();
    _history.clear();
    logger = null;
  }

  /// gets the current displayed page
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

/// interface used to listen for page changes
abstract class NavigationListener {

  /// handler which is called whenever the page changed
  void onNavigatedTo(Navigator sender, Page page, NavigationEventArgs args);
}

class HistoryItem {
  String uri;
  String id;
}

/// Represents a set of parameter used to pass information to another page while navigating
class NavigationParameter {
  static const String namespace = "modularity.core.NavigationParameter";
  final HashMap<String, Object> _parameter;
  final utility.Logger logger;

  /// Initializes the parameter set with the help of a [Map]
  NavigationParameter.fromMap(Map<String, Object> parameter, {this.logger}) : _parameter = parameter;

  /// Initializes an empty parameter set
  NavigationParameter({this.logger}) : _parameter = new HashMap<String, Object>();

  /// adds a new parameter [value] by its [name]
  void add(String name, Object value) {
    if(!contains(name)) {

    } else if(logger != null) {
      logger.log(new ParameterExistsWarning(namespace, name));
    }
  }

  /// checks whether a parameter with the given [name] exists
  bool contains(String name) => _parameter.containsKey(name);

  /// gets a specific parameter by its [name]
  Object operator [](String name) => _parameter[name];
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

class NavigationUri {
  String _path;

  NavigationUri.fromString(String uri) {
    _path = validateUri(uri);
  }

  String validateUri(String uri) {
    return uri;
  }

  String get path => _path;

  bool get isValid => true;

  bool get isInvalid => !isValid;

  //TODO implement toString
}

abstract class NavigationStrategy {
  bool shouldReplace(Page page, Page previousPage);
}

class DefaultNavigationStrategy implements NavigationStrategy {
  bool shouldReplace(Page page, Page previousPage) => false;
}

class ParameterExistsWarning extends utility.WarningMessage { //TODO rename to NavigationParameterExistsWarning
  final String _name;

  ParameterExistsWarning(String namespace, String name) : _name = name, super(namespace);

  @override
  String get message =>
  "Parameter with name => \"$_name\" already exists. You have to fix the duplicate to ensure that the application works as expected.";
}

class MissingParameterWarning extends utility.WarningMessage {
  final String _name;
  final String _uri;

  MissingParameterWarning(String namespace, String uri, String name) : _name = name, _uri = uri, super(namespace);

  @override
  String get message =>
  "Parameter with name => \"$_name\" is missing. Check whether the given parameter name for page with URI => \"$_uri\" is correct.";
}

