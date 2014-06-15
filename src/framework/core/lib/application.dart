part of lib.core;

/**
 * typedef to allow dependency injection
 * for injecting a config loader into
 * an application
 */
typedef ConfigLoader ConfigLoaderFactory();

class Application {
  bool _isStarted = false;
  bool _isLoaded = false;
  List<Page> _pages;
  String _name;
  String _version;
  String _language;
  String _startUri;
  String _author;

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
   * Initializes the application with the help
   * of a [configLoader]. If the debug mode is enabled
   * by setting [isInDebugMode] to true the debug console
   * will be visible
   */
  Application({this.configLoaderFactory, this.isInDebugMode: false});

  /**
   * Loads the config and starts the application
   */
  Future start() {
    var configLoader;

    //try to get injected config loader
    if(configLoaderFactory != null) {
      configLoader = configLoaderFactory();
    }

    //otherwise get default config loader
    else {
      configLoader = null; //TODO implement
    }

    return configLoader.load().then((data) {
      _pages = data.pages;
      //print(data.name); //TODO implement
      //_name = data.name;
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
   * Flag which indicates whether the
   * application is successfully loaded or not
   */
  bool get isLoaded => _isLoaded;

  /**
   * Gets all pages if the config could
   * be successfully loaded, otherwise it is null
   */
  void get pages => _pages;

  /**
   * Gets the name of the application
   */
  String get name => _name;

  //get tasks => _tasks;

  //get resources => _resources;

  get version => _version;

  get language => _language;

  get startUri => _startUri;

  get author => _author;
}
