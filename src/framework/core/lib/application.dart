part of modularity.core;

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
  static const String namespace = "modularity.core.Application";
  static const String DEFAULT_LANGUAGE = "en_EN";    //TODO move const to the language manager class
  bool _isStarted = false;
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
  bool get isStarted => _isStarted;

  /**
   * Initializes the application. If [logger]
   * is set the debug mode is enabled
   */
  Application(this.info, {this.logger}) :
    resources = new HashMap<String, Resource>(),
    tasks = new HashMap<String, BackgroundTask>(),
    pages = new HashMap<String, Page>();

  /**
   * Loads the config and starts the application
   */
  Future<Application> start() {
    if(!_isBusy && !_isStarted) {
      _isBusy = true;
      Completer completer = new Completer();
      completer.complete(this);

      return completer.future.then((instance) {


        _isStarted = true;
        _isBusy = false;
        return instance;
      });
    } else {
      //throw new ExecutionException();
    }
  }

  /**
   * Destructs and stops the application
   */
  Future<Application> stop() {
    if(!_isBusy && _isStarted) {
      _isBusy = true;
      Completer completer = new Completer();
      completer.complete(this);

      return completer.future.then((instance) {


        _isStarted = false;
        _isBusy = false;
        return instance;
      });
    } else {
      //throw new ExecutionException();
    }
  }

  /**
   * Adds all [pages] in list to the application
   */
  void addPages(List<Page> pagesCollection) {
    pages.addAll(new HashMap.fromIterable(pagesCollection, key: (page) {
      if(logger != null && pages.containsKey(page.uri)) {
        logger.logWarning(new PageExistsWarning(namespace, page.uri));
      }

      return page.uri;
    }));
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    if(logger != null && pages.containsKey(page.uri)) {
      logger.logWarning(new PageExistsWarning(namespace, page.uri));
    }

    pages[page.uri] = page;
  }

  /**
   * Adds all background [tasks] to the application
   */
  void addTasks(List<BackgroundTask> taskCollection) {
    tasks.addAll(new HashMap.fromIterable(taskCollection, key: (task) {
      if(logger != null && tasks.containsKey(task.name)) {
        logger.logWarning(new BackgroundTaskExistsWarning(namespace, task.name));
      }

      return task.name;
    }));
  }

  /**
   * Adds a single background [task] to the application
   */
  void addTask(BackgroundTask task) {
    if(logger != null && tasks.containsKey(task.name)) {
      logger.logWarning(new BackgroundTaskExistsWarning(namespace, task.name));
    }

    tasks[task.name] = task;
  }

  /**
   * Adds all [resources] to the application
   */
  void addResources(List<Resource> resourceCollection) {
    resources.addAll(new HashMap.fromIterable(resourceCollection, key: (resource) {
      if(logger != null && resources.containsKey(resource.name)) {
        logger.logWarning(new ResourceExistsWarning(namespace, resource.name));
      }

      return resource.name;
    }));
  }

  /**
   * Adds a single [resource] to the application
   */
  void addResource(Resource resource) {
    if(logger != null && resources.containsKey(resource.name)) {
      logger.logWarning(new ResourceExistsWarning(namespace, resource.name));
    }

    resources[resource.name] = resource;
  }
}
