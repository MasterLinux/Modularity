part of modularity.core;

/**
 * Representation of a language
 *
 *   //
 *   var german = new Language.fromCode("de_DE");
 *   var english = new Language.fromCode("en-US");
 *   var defaultLanguage = new Language();
 */
class Language {
  static const String defaultLanguage = "en";
  static const String defaultCountry = "US";

  String _language;
  String _country;

  Language.fromCode(String code) {
    var info = _parse(code);

    _language = info.language;
    _country = info.country;
  }

  factory Language({String language:defaultLanguage, String country:defaultCountry}) {
    return new Language.fromCode("${language}-${country}");
  }

  String get language => _language;

  String get country => _country;

  Language _parse(String code) {
    return null; //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${language}-${country}";
}

/**
 * Representation of a version
 *
 *   var version = new Version.fromString("1.2.43");
 *   var version = new Version.fromString("1.2.43_version-name");
 *
 */
class Version {
  String _major;
  String _minor;
  String _maintenance;
  String _name;

  Version.fromString(String versionString) {
    var info = _parse(versionString);

    _major = info.major;
    _minor = info.minor;
    _maintenance = info.maintenance;
    _name = info.name;
  }

  String get major => _major;

  String get minor => _minor;

  String get maintenance => _maintenance;

  String get name => _name;

  Version _parse(String version) {
    return null; //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${major}.${minor}.${maintenance}"; //TODO add version name if set
}

class Author {
  final String firstName;
  final String lastName;
  //TODO add company as new model class
  //TODO add email

  Author(this.firstName, this.lastName);
}

/**
 * Representation of an application
 */
class Application implements NavigationListener {
  static const String namespace = "modularity.core.Application";
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
   * Gets the name of the application
   */
  final String name;

  /**
   * Gets the current version number of the application
   */
  final Version version;

  /**
   * Gets the default language of the application
   */
  final Language language;

  /**
   * Gets the URI of the first displayed page
   */
  final String startUri;

  /**
   * Gets the the author of the application
   */
  final Author author;

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
   * Flag which indicates whether the
   * application is started or not
   */
  bool get isStarted => _isStarted;

  Application.fromConfig() {
    //TODO build application from config
  }

  /**
   * Initializes the application. If [logger]
   * is set the debug mode is enabled
   */
  Application(this.name, this.version, this.language, this.author, this.startUri, this.navigator, {this.logger}) :
    resources = new HashMap<String, Resource>(),
    tasks = new HashMap<String, Task>()
  {
    this.navigator.logger = logger;

    //validate application info
    _validateLanguage();
    _validateVersion();
    _validateName();
  }

  /**
   * Gets all registered pages
   */
  HashMap<String, Page> get pages => navigator.pages;

  /// Starts the application
  ///
  /// For example:
  ///     if(!application.isStarted) {
  ///       application.start().then((instance) {
  ///         //the call of start() must be completed before you can stop the application
  ///       });
  ///     }
  ///
  Future<Application> start() {
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
  Future<Application> stop() {
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
    if(stringUtil.isEmpty(startUri) && pages.isNotEmpty) {
      _validateStartUri(pages.first.uri);
    }

    navigator.addPages(pages);
  }

  /**
   * Adds a single [page] to the application
   */
  void addPage(Page page) {
    if(stringUtil.isEmpty(startUri)) {
      _validateStartUri(page.uri);
    }

    page.context = new ApplicationContext(this);

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

  /**
   * Checks whether the default language is set.
   * If not the default is set.
   */
  void _validateLanguage() { //TODO validate in language class
    if (stringUtil.isEmpty(info.language)) {
      info.language = defaultLanguage;

      if (logger != null) {
        logger.log(new MissingDefaultLanguageWarning(namespace));
      }
    }
  }

  /**
   * Checks whether the application name is set.
   * If not the default is set.
   */
  void _validateName() {
    if (stringUtil.isEmpty(info.name)) {
      info.name = defaultName;

      if (logger != null) {
        logger.log(new MissingApplicationNameError(namespace));
      }
    }
  }

  /**
   * Checks whether the application version is set.
   * If not the default is set.
   */
  void _validateVersion() { //TODO validate in Version class
    if (stringUtil.isEmpty(info.version)) {
      info.version = defaultVersion;

      if (logger != null) {
        logger.log(new MissingApplicationVersionError(namespace));
      }
    }
  }

  /**
   * Checks whether a start URI is set.
   * If not it tries to use the URI of
   * the first added page.
   */
  void _validateStartUri(String defaultUri) { //TODO create PageUri class with parser for validation
    if (stringUtil.isEmpty(info.startUri)) {
      info.startUri = defaultUri;
    }
  }
}
