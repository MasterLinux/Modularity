part of lib.core;

/**
 * Application data model which contains
 * each information to initialize an app
 */
class ApplicationInfo {

  /**
   * Gets or sets the name of the application
   */
  String name;

  /**
   * Gets or sets the current version number of the application
   */
  String version;

  /**
   * Gets or sets the language code of the current displayed language
   */
  String language;

  /**
   * Gets or sets the URI of the home page
   */
  String startUri;

  /**
   * Gets or sets the name of the author of the application
   */
  String author;
}

/**
 * Representation of an application
 */
class Application {
  bool _isStarted = false;
  Future _mainTask;

  /**
   * Flag which indicates whether the application
   * runs in debug mode or not
   */
  final bool isInDebugMode;

  /**
   * Contains all information
   * about the application
   */
  final ApplicationInfo info;

  /**
   * Gets all resources tasks if no resource is loaded
   * it returns an empty list
   */
  final HashMap<String, Resource> resources;

  /**
   * Gets all pages if no page is loaded
   * it returns an empty list
   */
  final HashMap<String, Page> pages;

  /**
   * Gets all background tasks if no task is loaded
   * it returns an empty list
   */
  final HashMap<String, Task> tasks;

  /**
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  /**
   * Initializes the application. Whenever [isInDebugMode]
   * is set to true the debug console will be visible
   */
  Application({this.info, this.pages, this.tasks, this.resources, this.isInDebugMode: false});

  /**
   * Loads the config and starts the application
   */
  Future start() {
    if(!_isStarted) {
      _isStarted = true;

      //start new main task
      _mainTask = new Future.microtask(() {
        //TODO initialize app
      }).whenComplete(() {
        _isStarted = true;
      });
    }

    return _mainTask;
  }

  /**
   * Destructs and stops the application
   */
  Future stop() {
    if(_isStarted) {
      _isStarted = false;
      //TODO stop application
    }
    return null;
  }
}
