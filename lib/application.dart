part of modularity.core;

/**
 * Representation of an application
 */
abstract class Application implements NavigationListener {
  static const String namespace = "modularity.core.Application";
  bool _isRunning = false;
  NavigationUri _startUri;
  Navigator _navigator;
  Language _language;
  Version _version;
  Author _author;
  String _name;

  final utility.Logger logger;
  final Manifest manifest;

  /**
   * Gets the navigator used to navigate
   * through pages
   */
  Navigator get navigator => _navigator;

  /**
   * Gets the name of the application
   */
  String get name => _name;

  /**
   * Gets the current version number of the application
   */
  Version get version => _version;

  /**
   * Gets the default language of the application
   */
  Language get language => _language;

  /**
   * Gets the URI of the first displayed page
   */
  NavigationUri get startUri => _startUri;

  /**
   * Gets the the author of the application
   */
  Author get author => _author;

  /**
   * Flag which indicates whether the
   * application is running or not
   */
  bool get isRunning => _isRunning;

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
  Application.fromManifest(this.manifest, {Navigator navigator, this.logger}) :
    resources = new HashMap<String, Resource>(),
    tasks = new HashMap<String, Task>()
  {
    _applyManifest(manifest.config).then((_) {

      if(navigator == null) {
        //TODO initialize navigator
      }
    });
  }

  /// Reads the manifest and initializes the application
  Future _applyManifest(ApplicationModel config) async {
    var context = new ApplicationContext(this);

    //get app info
    _startUri = config.startUri != null ? new NavigationUri.fromString(config.startUri) : new NavigationUri.fromString(config.pages.first.uri);
    _language = new Language.fromCode(config.language);
    _author = new Author(config.author, config.author);
    _version = new Version.fromString(config.version);
    _name = config.name;

    // add all pages
    for(var pageModel in config.pages) {
      var template = pageModel.template != null ? new ViewTemplate.fromModel(pageModel.template) : null;
      var uri = new NavigationUri.fromString(pageModel.uri);
      var page = new Page(uri, pageModel.title, context, template: template);

      // add all fragments
      for(var fragmentModel in pageModel.fragments) {
        var fragment = new Fragment(fragmentModel.parentId, page, context);

        //add all modules
        for(var moduleModel in fragmentModel.modules) {
          var module = new Module(
              moduleModel.lib,
              moduleModel.name,
              moduleModel.template,
              moduleModel.attributes,
              fragment,
              context
          );

          await module.load(); //TODO store all futures in list and load each concurrently? load in start() / run() method?

          fragment.addModule(module);
        }

        page.addFragment(fragment);
      }

      addPage(page);
    }
  }

  /// Starts the application
  ///
  /// For example:
  ///     if(!application.isRunning) {
  ///       await application.run();
  ///     }
  ///
  Future<Application> run() async {
    if(!isRunning) {
      _isRunning = true;

      navigator.addListener(this);
      await navigator.navigateTo(startUri, parameter: new NavigationParameter.fromMap({})); //TODO start page parameter required

    } else if(logger != null) {
      //TODO logger.log()...
      //throw new ExecutionException("application is already running");
    }

    return this;
  }

  void onNavigatedTo(Navigator sender, Page page, NavigationEventArgs args) {
    //does nothing
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

/**
 * An application context which
 * is an interface to all global
 * information
 */
class ApplicationContext {
  final Application application;

  ApplicationContext(this.application);

  String get applicationName => application.name;

  utility.Logger get logger => application.logger;
}
