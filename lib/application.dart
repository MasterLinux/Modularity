part of modularity.core;

class Config {
  NavigationUri startUri;
  Language language;
  Version version;
  Author author;
  String name;
}

/**
 * Representation of an application
 */
abstract class Application implements NavigationListener {
  static const String namespace = "modularity.core.Application";
  bool _isStarted = false;
  bool _isBusy = false;
  Navigator _navigator;
  Logger _logger;

  final Config config;

  /**
   * Gets the navigator used to navigate
   * through pages
   */
  Navigator get navigator => _navigator;

  /**
   * Gets the name of the application
   */
  String get name => config.name;

  /**
   * Gets the current version number of the application
   */
  Version get version => config.version;

  /**
   * Gets the default language of the application
   */
  Language get language => config.language;

  /**
   * Gets the URI of the first displayed page
   */
  NavigationUri get startUri => config.startUri;

  /**
   * Gets the the author of the application
   */
  Author get author => config.author;

  /**
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  /**
   * Gets all registered pages
   */
  HashMap<String, Page> get pages => navigator.pages;

  /**
   * Gets all resources tasks if no resource is loaded
   * it returns an empty list
   */
  final HashMap<String, Resource> resources; //TODO move to resource manager

  /**
   * Gets all background tasks if no task is loaded
   * it returns an empty list
   */
  final HashMap<String, Task> tasks; //TODO move to task queue

  /**
   * Initializes the application
   */
  Application.fromConfig(this.config, {Navigator navigator, Logger logger}) :
    resources = new HashMap<String, Resource>(),
    tasks = new HashMap<String, Task>()
  {
    _logger = logger;

    if(navigator == null) {
      //TODO initialize navigator
    }
  }

  void _loadConfig(String config) {
    //TODO implement
  }

  /// Starts the application
  ///
  /// For example:
  ///     if(!application.isStarted) {
  ///       application.start().then((instance) {
  ///         //the call of start() must be completed before you can stop the application
  ///       });
  ///     }
  ///
  Future<Application> start() { //TODO use async keyword
    if(!_isBusy && !_isStarted) {
      _isBusy = true;
      Completer<Application> completer = new Completer<Application>();
      completer.complete(this);

      return completer.future.then((instance) {
        instance.navigator.addListener(instance);

        //TODO start page parameter required
        return instance.navigator.navigateTo(instance.info.startUri).then((_) {
          _isStarted = true;
          _isBusy = false;

          return instance;
        });
      });
    } else if(_isBusy) {
      throw new ExecutionException("start can only be called once");
    } else {
      throw new ExecutionException("application is already running");
    }
  }

  /// Stops the application
  ///
  /// For example:
  ///     if(application.isStarted) {
  ///       application.stop().then((instance) {
  ///         //the call of stop() must be completed before you start the application again
  ///       });
  ///     }
  ///
  Future<Application> stop() { //TODO use async keyword
    if(!_isBusy && _isStarted) {
      _isBusy = true;
      Completer<Application> completer = new Completer<Application>();
      completer.complete(this);

      return completer.future.then((instance) {
        instance.navigator.clear();

        _isStarted = false;
        _isBusy = false;
        return instance;
      });
    } else if(_isBusy) {
      throw new ExecutionException("stop can only be called once");
    } else {
      throw new ExecutionException("stop can only be called if application is currently running");
    }
  }

  void onNavigatedTo(Navigator sender, Page page, NavigationEventArgs args) {
    //does nothing
  }

  /**
   * Adds all [pages] in list to the application
   */
  void addPages(List<Page> pages) {
    if((startUri == null || startUri.isInvalid) && pages.isNotEmpty) {
      config.startUri = new NavigationUri.fromString(pages.first.uri);
    }

    navigator.addPages(pages);
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    if(startUri == null || startUri.isInvalid) {
      config.startUri = new NavigationUri.fromString(page.uri);
    }

    page.context = new ApplicationContext(this);

    navigator.addPage(page);
  }

  /**
   * Adds all background [tasks] to the application
   */
  void addTasks(List<Task> taskCollection) {
    tasks.addAll(new HashMap.fromIterable(taskCollection, key: (task) {
      if(_logger != null && tasks.containsKey(task.name)) {
        _logger.log(new TaskExistsWarning(namespace, task.name));
      }

      return task.name;
    }));
  }

  /**
   * Adds a single background [task] to the application
   */
  void addTask(Task task) {
    if(_logger != null && tasks.containsKey(task.name)) {
      _logger.log(new TaskExistsWarning(namespace, task.name));
    }

    tasks[task.name] = task;
  }

  /**
   * Adds all [resources] to the application
   */
  void addResources(List<Resource> resourceCollection) {
    resources.addAll(new HashMap.fromIterable(resourceCollection, key: (resource) {
      if(_logger != null && resources.containsKey(resource.name)) {
        _logger.log(new ResourceExistsWarning(namespace, resource.name));
      }

      return resource.name;
    }));
  }

  /**
   * Adds a single [resource] to the application
   */
  void addResource(Resource resource) {
    if(_logger != null && resources.containsKey(resource.name)) {
      _logger.log(new ResourceExistsWarning(namespace, resource.name));
    }

    resources[resource.name] = resource;
  }
}
