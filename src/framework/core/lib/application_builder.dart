part of lib.core;

class ApplicationBuilder {
  HashMap<String, Resource> _resources;
  HashMap<String, Page> _pages;
  HashMap<String, Task> _tasks;
  bool _isInDebugMode;
  String _author;
  String _name;
  String _version;
  String _startUri;
  String _language;
  String _firstPageUri;

  ApplicationBuilder(String name, String version) {
    _resources = new HashMap<String, Resource>();
    _pages = new HashMap<String, Page>();
    _tasks = new HashMap<String, Task>();
    _isInDebugMode = false;
    _version = version;
    _name = name;
  }

  ApplicationBuilder setDebugModeEnabled(bool debugModeEnabled) {
    _isInDebugMode = debugModeEnabled;
  }

  ApplicationBuilder setAuthor(String author) {
    _author = author;
  }

  ApplicationBuilder setStartUri(String startUri) {
    _startUri = startUri;
  }

  /**
   * Sets the default [language]
   */
  ApplicationBuilder setLanguage(String language) {
    _language = language;
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
  }

  ApplicationBuilder addPage(Page page) {
    if(_pages.containsKey(page.uri)) {
      //TODO log warning
    } else if(_firstPageUri == null) {
      _firstPageUri = page.uri;
    }

    _pages[page.uri] = page;
  }

  ApplicationBuilder addTasks(List<Task> tasks) {
    _tasks.addAll(new HashMap.fromIterable(tasks, key: (task) => task.id));
  }

  ApplicationBuilder addTask(Task task) { //TODO log warning if task with specific id already exists
    _tasks[task.id] = task;
  }

  ApplicationBuilder addResources(List<Resource> resources) {
    _resources.addAll(new HashMap.fromIterable(resources, key: (resource) => resource.name));
  }

  ApplicationBuilder addResource(Resource resource) { //TODO log warning if resource with specific name already exists
    _resources[resource.name] = resource;
  }

  /**
   * Builds the application
   */
  Application build() {
    var info = new ApplicationInfo();

    info.language = _language != null ? _language : "en_EN";

    if(_startUri == null && _pages.isNotEmpty) {
      info.startUri = _firstPageUri;
    } else {
      info.startUri = _startUri;
    }

    info.author = _author;
    info.version = _version;
    info.name = _name;

    var application = new Application(
      isInDebugMode: _isInDebugMode,
      resources: _resources,
      pages: _pages,
      tasks: _tasks,
      info: info
    );
  }
}
