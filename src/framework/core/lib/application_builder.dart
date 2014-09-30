part of lib.core;

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

  ApplicationBuilder(String name, String version) {
    _tasks = new HashMap<String, BackgroundTask>();
    _resources = new HashMap<String, Resource>();
    _pages = new HashMap<String, Page>();
    _isInDebugMode = false;
    _version = version;
    _name = name;
  }

  ApplicationBuilder setDebugModeEnabled(bool debugModeEnabled) {
    _isInDebugMode = debugModeEnabled;
    return this;
  }

  ApplicationBuilder setAuthor(String author) {
    _author = author;
    return this;
  }

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

  ApplicationBuilder addPage(Page page) {
    if(_pages.containsKey(page.uri)) {
      //TODO log warning
    } else if(_firstPageUri == null) {
      _firstPageUri = page.uri;
    }

    _pages[page.uri] = page;
    return this;
  }

  ApplicationBuilder addTasks(List<BackgroundTask> tasks) {
    _tasks.addAll(new HashMap.fromIterable(tasks, key: (task) => task.id));
    return this;
  }

  ApplicationBuilder addTask(BackgroundTask task) { //TODO log warning if task with specific id already exists
    _tasks[task.id] = task;
    return this;
  }

  ApplicationBuilder addResources(List<Resource> resources) {
    _resources.addAll(new HashMap.fromIterable(resources, key: (resource) => resource.name));
    return this;
  }

  ApplicationBuilder addResource(Resource resource) { //TODO log warning if resource with specific name already exists
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
