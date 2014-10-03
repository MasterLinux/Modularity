part of lib.core;

/**
 * Builder class used to create and setup an application
 */
class ApplicationBuilder {
  static const String NAMESPACE = "modularity.core.ApplicationBuilder";
  HashMap<String, BackgroundTask> _tasks;
  HashMap<String, Resource> _resources;
  HashMap<String, Page> _pages;
  Logger logger;
  String _author;
  String _name;
  String _version;
  String _startUri;
  String _language;
  String _firstPageUri;

  /**
   * Initializes the builder. The [name] and the
   * [version] is required to build an application.
   * The [logger] is used to used to log warnings, errors, etc.
   * and is used as default [logger] in the [Application]. If the
   * [logger] isn't set the debug mode is disabled.
   */
  ApplicationBuilder(String name, String version, {this.logger}) {
    _tasks = new HashMap<String, BackgroundTask>();
    _resources = new HashMap<String, Resource>();
    _pages = new HashMap<String, Page>();
    _version = version;
    _name = name;
  }

  /**
   * Sets the name of the [author]
   */
  ApplicationBuilder setAuthor(String author) {
    _author = author;
    return this;
  }

  /**
   * Sets the URI of the first page to display on app start
   */
  ApplicationBuilder setStartUri(String startUri) {
    _startUri = startUri;
    return this;
  }

  /**
   * Sets the default [language]
   */
  ApplicationBuilder setLanguage(String language) {
    _language = language;
    return this;
  }

  /**
   * Adds all [pages] in list to the application
   */
  ApplicationBuilder addPages(List<Page> pages) {
    _pages.addAll(new HashMap.fromIterable(pages, key: (page) {
      if(logger != null && _pages.containsKey(page.uri)) {
        logger.logWarning(new PageExistsWarning(NAMESPACE, page.uri));
      } else if(_firstPageUri == null) {
        _firstPageUri = page.uri;
      }

      return page.uri;
    }));
    return this;
  }

  /**
   * Adds a single [page] to the application
   */
  ApplicationBuilder addPage(Page page) {
    if(logger != null && _pages.containsKey(page.uri)) {
      logger.logWarning(new PageExistsWarning(NAMESPACE, page.uri));
    } else if(_firstPageUri == null) {
      _firstPageUri = page.uri;
    }

    _pages[page.uri] = page;
    return this;
  }

  /**
   * Adds all background [tasks] to the application
   */
  ApplicationBuilder addTasks(List<BackgroundTask> tasks) {
    _tasks.addAll(new HashMap.fromIterable(tasks, key: (task) {
      if(logger != null && _tasks.containsKey(task.id)) {
        logger.logWarning(new BackgroundTaskExistsWarning(NAMESPACE, task.id));
      }

      return task.id;
    }));
    return this;
  }

  /**
   * Adds a single background [task] to the application
   */
  ApplicationBuilder addTask(BackgroundTask task) {
    if(logger != null && _tasks.containsKey(task.id)) {
      logger.logWarning(new BackgroundTaskExistsWarning(NAMESPACE, task.id));
    }

    _tasks[task.id] = task;
    return this;
  }

  /**
   * Adds all [resources] to the application
   */
  ApplicationBuilder addResources(List<Resource> resources) {
    _resources.addAll(new HashMap.fromIterable(resources, key: (resource) {
      if(logger != null && _resources.containsKey(resource.name)) {
        logger.logWarning(new ResourceExistsWarning(NAMESPACE, resource.name));
      }

      return resource.name;
    }));
    return this;
  }

  /**
   * Adds a single [resource] to the application
   */
  ApplicationBuilder addResource(Resource resource) {
    if(logger != null && _resources.containsKey(resource.name)) {
      logger.logWarning(new ResourceExistsWarning(NAMESPACE, resource.name));
    }

    _resources[resource.name] = resource;
    return this;
  }

  /**
   * Builds the application
   */
  Application build() {
    var info = new ApplicationInfo();

    info.language = _language != null ? _language : Application.DEFAULT_LANGUAGE;

    if(_startUri == null && _pages.isNotEmpty) {
      info.startUri = _firstPageUri;
    } else {
      info.startUri = _startUri;
    }

    info.author = _author;
    info.version = _version;
    info.name = _name;

    return new Application(
      logger: logger,
      resources: _resources,
      pages: _pages,
      tasks: _tasks,
      info: info
    );
  }
}
