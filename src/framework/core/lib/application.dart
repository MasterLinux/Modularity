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
class Application implements NavigationListener {
  static const String namespace = "modularity.core.Application";
  static const String defaultLanguage = "en_EN";    //TODO move const to the language manager class
  static const String defaultVersion = "1.0.0";
  static const String defaultName = "undefined";
  bool _isStarted = false;
  bool _isBusy = false;

  /**
   * Gets the navigator used to navigate
   * through pages
   */
  final Navigator navigator;

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
  final HashMap<String, Resource> resources; //TODO move to resource manager

  /**
   * Gets all registered pages
   */
  HashMap<String, Page> get pages {
    return navigator.pages;
  }

  /**
   * Gets all background tasks if no task is loaded
   * it returns an empty list
   */
  final HashMap<String, Task> tasks; //TODO move to task queue

  /**
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  /**
   * Initializes the application. If [logger]
   * is set the debug mode is enabled
   */
  Application(this.info, this.navigator, {this.logger}) :
    resources = new HashMap<String, Resource>(),
    tasks = new HashMap<String, Task>()
  {
    this.navigator.logger = logger;

    if(stringUtil.isEmpty(info.language)) {
      info.language = defaultLanguage;

      if(logger != null) {
        logger.log(new MissingDefaultLanguageWarning(namespace));
      }
    }

    if(stringUtil.isEmpty(info.name)) {
      info.name = defaultName;

      if(logger != null) {
        logger.log(new MissingApplicationNameError(namespace));
      }
    }

    if(stringUtil.isEmpty(info.version)) {
      info.version = defaultVersion;

      if(logger != null) {
        logger.log(new MissingApplicationVersionError(namespace));
      }
    }
  }

  /**
   * Loads the config and starts the application
   */
  Future<Application> start() {
    if(!_isBusy && !_isStarted) {
      _isBusy = true;
      Completer completer = new Completer();
      completer.complete(this);

      return completer.future.then((Application instance) {
        instance.navigator
            ..addListener(instance)
            ..navigateTo(instance.info.startUri);  //TODO start page parameter required

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

      return completer.future.then((Application instance) {
        instance.navigator.clear();

        _isStarted = false;
        _isBusy = false;
        return instance;
      });
    } else {
      //throw new ExecutionException();
    }
  }

  void onNavigatedTo(Navigator sender, Page page, NavigationEventArgs args) {
    //TODO track lifecycle
  }

  /**
   * Adds all [pages] in list to the application
   */
  void addPages(List<Page> pages) {
    navigator.addPages(pages);
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    navigator.addPage(page);
  }

  /**
   * Adds all background [tasks] to the application
   */
  void addTasks(List<Task> taskCollection) {
    tasks.addAll(new HashMap.fromIterable(taskCollection, key: (task) {
      if(logger != null && tasks.containsKey(task.name)) {
        logger.log(new TaskExistsWarning(namespace, task.name));
      }

      return task.name;
    }));
  }

  /**
   * Adds a single background [task] to the application
   */
  void addTask(Task task) {
    if(logger != null && tasks.containsKey(task.name)) {
      logger.log(new TaskExistsWarning(namespace, task.name));
    }

    tasks[task.name] = task;
  }

  /**
   * Adds all [resources] to the application
   */
  void addResources(List<Resource> resourceCollection) {
    resources.addAll(new HashMap.fromIterable(resourceCollection, key: (resource) {
      if(logger != null && resources.containsKey(resource.name)) {
        logger.log(new ResourceExistsWarning(namespace, resource.name));
      }

      return resource.name;
    }));
  }

  /**
   * Adds a single [resource] to the application
   */
  void addResource(Resource resource) {
    if(logger != null && resources.containsKey(resource.name)) {
      logger.log(new ResourceExistsWarning(namespace, resource.name));
    }

    resources[resource.name] = resource;
  }
}
