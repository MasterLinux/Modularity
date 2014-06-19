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
ConfigLoaderFactory _defaultConfigLoader = () => new RestApiConfigLoader();

/**
 * Representation of an application
 */
class Application {
  ApplicationData _appData;
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
        throw new ApplicationLoadingError();
      }
      return data;
    })

    //load pages
    .then((data) {
      if(!_loadPages(data.pages)) {
        throw new Error(); //TODO use custom error instead
      }
      return data;
    })

    //load tasks
    .then((data) {
      if(!_loadTasks(data.tasks)) {
        throw new Error(); //TODO use custom error instead
      }
      return data;
    })

    //load resources
    .then((data) {
      if(!_loadResources(data.resources)) {
        throw new Error(); //TODO use custom error instead
      }
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
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  /**
   * Gets all pages if the config could
   * be successfully loaded, otherwise it is null
   */
  List<Page> get pages => _appData.pages;

  /**
   * Gets all background tasks if the config could
   * be successfully loaded, otherwise it is null
   */
  List<Task> get tasks => _appData.tasks;

  /**
   * Gets all resources tasks if the config could
   * be successfully loaded, otherwise it is null
   */
  List<Resource> get resources => _appData.resources;

  /**
   * Gets the name of the application
   */
  String get name => _appData.name;

  /**
   * Gets the current version number of the application
   */
  String get version => _appData.version;

  /**
   * Gets the language code of the current displayed language
   */
  String get language => _appData.language;

  /**
   * Gets the URI of the home page
   */
  String get startUri => _appData.startUri;

  /**
   * Gets the name of the author of the application
   */
  String get author => _appData.author;
}
