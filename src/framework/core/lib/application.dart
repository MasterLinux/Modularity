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

  /**
   * The config loader which is used
   * to load the application with the
   * help of a config
   */
  final ConfigLoaderFactory configLoader;

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
  Application(this.configLoader, {this.isInDebugMode: false});

  /**
   * Loads the config and starts the application
   */
  Future start() {
    return null;
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
}
