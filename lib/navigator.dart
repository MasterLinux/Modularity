part of modularity.core;

typedef NavigationStrategy NavigationStrategyFactory();

NavigationStrategy _defaultNavigationStrategy() => new DefaultNavigationStrategy();

class Navigator {
  static const String navigationIdPrefix = "navigation";
  static const String namespace = "modularity.core.Navigator";

  final HashMap<String, NavigationEventArgs> _parameterCache;
  final NavigationStrategyFactory strategy;
  final List<HistoryItem> _history;
  final Router _router;
  Page _currentPage;
  utility.Logger logger;

  /**
   * Gets all pages if no page is loaded
   * it returns an empty list
   */
  final HashMap<NavigationUri, Page> pages;

  /// initializes the navigator with a specific [NavigationStrategy]
  /// if no [strategy] is set the default strategy is used
  Navigator({this.strategy: _defaultNavigationStrategy}) :
  pages = new HashMap<NavigationUri, Page>(),
  _parameterCache = new HashMap<String, NavigationEventArgs>(),
  _history = new List<HistoryItem>(),
  _router = new Router() {
    _router.root
      ..addRoute(name: 'page', path: '/page/:uri/:id', enter: _openPage);

    _router.listen();
  }

  void _cacheNavigationParameter(NavigationUri uri, String navigationId, NavigationParameter parameter) {
    var args = new NavigationEventArgs(uri, parameter: parameter);
    var key = "${uri.path}_${navigationId}";
    _parameterCache[key] = args;
  }

  NavigationEventArgs _getCachedNavigationParameter(NavigationUri uri, String navigationId) {
    var key = "${uri.path}_${navigationId}";
    return _parameterCache[key];
  }

  Future _openPage(RouteEvent e) async {
    var uri = new NavigationUri.fromString(e.parameters['uri']);
    var navigationId = e.parameters['id'];

    if (pages.containsKey(uri)) {
      var args = _getCachedNavigationParameter(uri, navigationId);
      var historyItem = new HistoryItem()
        ..id = navigationId
        ..uri = uri;

      if (_currentPage != null) {
        await _currentPage.close();
      }

      _currentPage = pages[uri];
      await _currentPage.open(args);
      _history.add(historyItem);
    }

    else if (logger != null) {
      logger.log(new MissingPageWarning(namespace, uri.path));
    }
  }

  /// opens a specific [Page] with the help of its [uri]
  Future navigateTo(NavigationUri uri, {NavigationParameter parameter}) async {
    if (pages.containsKey(uri)) {
      var navigationId = new utility.UniqueId(navigationIdPrefix).build();
      var navigationStrategy = strategy();

      _cacheNavigationParameter(uri, navigationId, parameter);

      await _router.go('page', {'uri': uri.path, 'id': navigationId},
      replace: navigationStrategy.shouldReplace(pages[uri], _currentPage)
      );
    }

    else if (logger != null) {
      logger.log(new MissingPageWarning(namespace, uri.path));
    }
  }

  /// opens the previous [Page]
  Future navigateBack() async {
    //remove current page from history
    _history.removeLast();

    if (_history.isNotEmpty) {
      var historyItem = _history.last;
      var args = _getCachedNavigationParameter(historyItem.uri, historyItem.id);
      args = new NavigationEventArgs(args.uri, parameter:args.parameter, isNavigatedBack:true);

      //TODO implement back navigation
    }
  }

  /// cleans up the navigator
  void clear() {
    if (_currentPage != null) {
      _currentPage.close();
      _currentPage = null;
    }

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
  void addPages(List<Page> pages) {
    this.pages.addAll(new HashMap.fromIterable(pages, key: (page) {
      if (logger != null && this.pages.containsKey(page.uri)) {
        logger.log(new PageExistsWarning(namespace, page.uri));
      }

      return page.uri;
    }));
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    if (logger != null && pages.containsKey(page.uri)) {
      logger.log(new PageExistsWarning(namespace, page.uri.toString()));
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
  NavigationUri uri;
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
    if (!contains(name)) {

    } else if (logger != null) {
      logger.log(new ParameterExistsWarning(namespace, name));
    }
  }

  /// checks whether a parameter with the given [name] exists
  bool contains(String name) => _parameter.containsKey(name);

  /// gets a specific parameter by its [name]
  Object operator [](String name) => _parameter[name];
}

class NavigationEventArgs implements EventArgs {
  final NavigationParameter parameter;
  final bool isNavigatedBack;
  final NavigationUri uri;

  NavigationEventArgs(this.uri, {this.isNavigatedBack: false, this.parameter});
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

  operator ==(another) => another is NavigationUri && another.path == path;

  int get hashCode => quiver.hash2(path.hashCode, isInvalid.hashCode);

//TODO implement toString
}

abstract class NavigationStrategy {
  bool shouldReplace(Page page, Page previousPage);
}

class DefaultNavigationStrategy implements NavigationStrategy {
  bool shouldReplace(Page page, Page previousPage) => false;
}

class ParameterExistsWarning extends utility.WarningMessage {
  //TODO rename to NavigationParameterExistsWarning
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

