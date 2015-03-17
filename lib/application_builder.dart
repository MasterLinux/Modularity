part of modularity.core;

/**
 * Builder class used to create and setup an application
 */
class ApplicationBuilder {
  static const String namespace = "modularity.core.ApplicationBuilder";
  final List<Task> _tasks;
  final List<Resource> _resources;
  final List<Page> _pages;
  final utility.Logger logger;
  final String _version;
  final String _name;
  String _author;
  String _startUri;
  String _language;

  /**
   * Initializes the builder. The [name] and the
   * [version] is required to build an application.
   * The [logger] is used to used to log warnings, errors, etc.
   * and is used as default [logger] in the [Application]. If the
   * [logger] isn't set the debug mode is disabled.
   */
  ApplicationBuilder(String name, String version, {this.logger}) :
    _tasks = new List<Task>(),
    _resources = new List<Resource>(),
    _pages = new List<Page>(),
    _version = version,
    _name = name;

  /**
   * Sets the name of the [author]
   */
  set author(String author) => _author = author;

  /**
   * Sets the URI of the first page to display on app start
   */
  set startUri(String startUri) => _startUri = startUri;

  /**
   * Sets the default [language]
   */
  set language(String language) => _language = language;

  /**
   * Adds all [pages] in list to the application
   */
  void addPages(List<ConfigPageModel> pages) {
    for(var page in pages) {
      addPage(page);
    }
  }

  /**
   * Adds a [Page] to the application with the help
   * of a [ConfigPageModel]
   */
  void addPage(ConfigPageModel pageConfig) {
    if(_pages.where((p) => p.uri == pageConfig.uri).isEmpty) {
      var page = new Page(pageConfig.uri, pageConfig.title, logger:logger);

      //construct fragments
      for(var fragmentConfig in pageConfig.fragments.objects) {
        var fragment = new Fragment(fragmentConfig.parentId, logger:logger);

        //construct modules
        for(var moduleConfig in fragmentConfig.modules.objects) {
          fragment.addModule(new Module(
              moduleConfig.lib,
              moduleConfig.name,
              moduleConfig.template,
              moduleConfig.config,
              logger: logger
          ));
        }

        page.addFragment(fragment);
      }

      _pages.add(page);

    } else if(logger != null) {
      logger.log(new PageExistsWarning(namespace, pageConfig.uri));
    }
  }

  /**
   * Adds all background [tasks] to the application
   */
  void addTasks(List<ConfigTaskModel> tasks) {
    for(var task in tasks) {
      addTask(task);
    }
  }

  /**
   * Adds a single background [task] to the application
   */
  void addTask(ConfigTaskModel task) {
    if(_tasks.where((t) => t.name == task.name).isEmpty) {
      _tasks.add(new Task(task.name));
    } else if(logger != null) {
      logger.log(new TaskExistsWarning(namespace, task.name));
    }
  }

  /**
   * Adds all [resources] to the application
   */
  void addResources(List<ConfigResourceModel> resources) {
    for(var resource in resources) {
      addResource(resource);
    }
  }

  /**
   * Adds a single [resource] to the application
   */
  void addResource(ConfigResourceModel resource) {
    var name = Resource.buildName(resource.languageCode, resource.languageName);

    if(_resources.where((r) => r.name == name).isEmpty) {
      _resources.add(new Resource(resource.languageCode, resource.languageName));
      //TODO find solution to add text resources
    } else if(logger != null) {
      logger.log(new ResourceExistsWarning(namespace, name));
    }
  }

  /**
   * Builds the application
   */
  Application build() {
    var info = new ApplicationInfo()
      ..startUri = _startUri == null && _pages.isNotEmpty ? _pages.first.uri : _startUri
      ..language = _language != null ? _language : Application.defaultLanguage
      ..author = _author
      ..version = _version
      ..name = _name;

    var application = new Application(info, new Navigator(), logger: logger)
      ..addResources(_resources)
      ..addPages(_pages)
      ..addTasks(_tasks);

    return application;
  }
}
