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
  static final String DEFAULT_LANGUAGE = "en_EN";
  Future<Application> _mainTask;
  bool _isBusy = false;

  /**
   * Logger used in this application.
   * If logger is [null] the debug mode
   * is disabled
   */
  final Logger logger;

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
  final HashMap<String, BackgroundTask> tasks;

  /**
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isBusy;

  /**
   * Initializes the application. If [logger]
   * is set the debug mode is enabled
   */
  Application({this.info, this.pages, this.tasks, this.resources, this.logger});

  /**
   * Loads the config and starts the application
   */
  Future start() {
    if(!_isBusy) {
      _isBusy = true;
      _mainTask = _buildTask();

      //start new main task
      _mainTask.then((instance) {
        //TODO initialize app
      }).whenComplete(() {
        _isBusy = false;
      });
    }

    return _mainTask;
  }

  /**
   * Destructs and stops the application
   */
  Future stop() {
    if(_isBusy) {
      _isBusy = false;
      //TODO stop application
    }
    return null;
  }

  /**
   * Gets the main task
   */
  Future<Application> _buildTask() {
    Completer completer;
    completer.complete(this);

    return completer.future;
  }
}
