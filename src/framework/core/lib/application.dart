part of lib.core;

/**
 * typedef to allow dependency injection
 * for injecting a config loader into
 * an application
 */
typedef ConfigLoader ConfigLoaderFactory();

/**
 * The default config loader used whenever
 * no custom loader is injected
 */
ConfigLoader _defaultConfigLoader() => new RestApiConfigLoader();

/**
 * Representation of an application
 */
class Application {
  ApplicationData _appData = new ApplicationData();
  bool _isStarted = false;
  List<Page> _pages;

  /**
   * The config loader which is used
   * to load the application with the
   * help of a config
   */
  final ConfigLoaderFactory configLoaderFactory;

  /**
   * Flag which indicates whether the application
   * runs in debug mode or not
   */
  final bool isInDebugMode;

  /**
   * Initializes the application. It is possible to inject a config
   * loader by setting a [configLoaderFactory] if not used the default
   * config loader is used to initialize the app. Whenever [isInDebugMode]
   * is set to true the debug console will be visible
   */

  Application({this.configLoaderFactory: _defaultConfigLoader, this.isInDebugMode: false});

  /**
   * Loads the config and starts the application
   */
  Future start() {
    return configLoaderFactory().load()

    //get app data
    .then((data) {
      //check whether the config could be loaded
      if((_appData = data) == null) {
        throw new ApplicationLoadingException();
      }
      return data;
    })

    //load pages
    .then((data) {
      if(!_loadPages(data.pages)) {
        throw new ApplicationLoadingException(); //TODO allow custom message
      }
      return data;
    })

    //load tasks
    .then((data) {
      _loadTasks(data.tasks);
      return data;
    })

    //load resources
    .then((data) {
      _loadResources(data.resources);
      return data;
    })

    //finish loading
    .whenComplete(() { //TODO check when _isStarted should be set to false
      _isStarted = true;
    });
  }

  /**
   * Destructs and stops the application
   */
  Future stop() {
    return null;
  }

  /**
   * Loads all pages and returns true
   * if the given list is not null and not empty,
   * false otherwise
   */
  _loadPages(List<Page> pages) {
    bool isLoaded = false;

    if(pages != null && pages.length > 0) {
      //TODO implement
      isLoaded = true;
    }

    return isLoaded;
  }

  _loadTasks(List<Task> pages) {

  }

  _loadResources(List<Resource> pages) {

  }

  /**
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  /**
   * Gets all pages if no page is loaded
   * it returns an empty list
   */
  List<Page> get pages => _appData.pages != null ? _appData.pages : new List<Page>();

  /**
   * Gets all background tasks if no task is loaded
   * it returns an empty list
   */
  List<Task> get tasks => _appData.tasks != null ? _appData.tasks : new List<Task>();

  /**
   * Gets all resources tasks if no resource is loaded
   * it returns an empty list
   */
  List<Resource> get resources => _appData.resources != null ? _appData.resources : new List<Resource>();

  /**
   * Gets the name of the application
   * or null if no application name is set
   */
  String get name => _appData.name;

  /**
   * Gets the current version number of the application
   * or null if no version number is set
   */
  String get version => _appData.version;

  /**
   * Gets the language code of the current displayed language
   * or null if no default language is set
   */
  String get language => _appData.language;

  /**
   * Gets the URI of the home page
   */
  String get startUri => _appData.startUri;

  /**
   * Gets the name of the author of the application
   * or null if no name is set
   */
  String get author => _appData.author;
}
