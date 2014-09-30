part of lib.core;

/**
 * Builder class used to create and setup an application
 */
class ApplicationBuilder {
  HashMap<String, BackgroundTask> _tasks;
  HashMap<String, Resource> _resources;
  HashMap<String, Page> _pages;
  bool _isInDebugMode;
  String _author;
  String _name;
  String _version;
  String _startUri;
  String _language;
  String _firstPageUri;

  /**
   * Initializes the builder. The [name] and the
   * [version] is required to build an application
   */
  ApplicationBuilder(String name, String version) {
    _tasks = new HashMap<String, BackgroundTask>();
    _resources = new HashMap<String, Resource>();
    _pages = new HashMap<String, Page>();
    _isInDebugMode = false;
    _version = version;
    _name = name;
  }

  /**
   * Enables or disables the debug mode
   */
  ApplicationBuilder setDebugModeEnabled(bool debugModeEnabled) {
    _isInDebugMode = debugModeEnabled;
    return this;
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
      if(_pages.containsKey(page.uri)) {
        //TODO log warning
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
    if(_pages.containsKey(page.uri)) {
      //TODO log warning
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
      if(_tasks.containsKey(task.id)) {
        //TODO log warning
      }

      return task.id;
    }));
    return this;
  }

  /**
   * Adds a single background [task] to the application
   */
  ApplicationBuilder addTask(BackgroundTask task) {
    if(_tasks.containsKey(task.id)) {
      //TODO log warning
    }

    _tasks[task.id] = task;
    return this;
  }

  /**
   * Adds all [resources] to the application
   */
  ApplicationBuilder addResources(List<Resource> resources) {
    _resources.addAll(new HashMap.fromIterable(resources, key: (resource) {
      if(_resources.containsKey(resource.name)) {
        //TODO log warning
      }

      return resource.name;
    }));
    return this;
  }

  /**
   * Adds a single [resource] to the application
   */
  ApplicationBuilder addResource(Resource resource) {
    if(_resources.containsKey(resource.name)) {
      //TODO log warning
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
      isInDebugMode: _isInDebugMode,
      resources: _resources,
      pages: _pages,
      tasks: _tasks,
      info: info
    );
  }
}
