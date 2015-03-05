part of modularity.tests.mock;

class ConfigLoaderMock extends ConfigLoader {
  static String APPLICATION_NAME = "App Title";
  static String APPLICATION_VERSION = "App Title";
  static String APPLICATION_LANGUAGE = "App Title";
  static String APPLICATION_START_URI = "App Title";
  static String APPLICATION_AUTHOR = "App Title";
  static int PAGE_COUNT = 2;
  static int TASK_COUNT = 3;
  static int RESOURCE_COUNT = 4;
  static String PAGE_TITLE = "Page Title";

  //excludes
  bool _excludeVersion = false;
  bool _excludeAuthor = false;
  bool _excludeName = false;
  bool _excludeStartUri = false;
  bool _excludeLanguage = false;
  bool _excludePages = false;
  bool _excludeTasks = false;
  bool _excludeResources = false;

  ConfigLoaderMock();

  ConfigLoaderMock.exclude({
    bool version: false, bool author: false,
    bool name: false, bool startUri: false,
    bool language: false, bool pages: false,
    bool tasks: false, bool resources: false
  }) {
    _excludeVersion = version;
    _excludeAuthor = author;
    _excludeName = name;
    _excludeStartUri = startUri;
    _excludeLanguage = language;
    _excludePages = pages;
    _excludeTasks = tasks;
    _excludeResources = resources;
  }

  bool get isLoaded {
    return true;
  }

  Future<ApplicationInfo> load() {
    var model = new ApplicationInfo();

    if(!_excludeVersion) model.version = APPLICATION_VERSION;
    if(!_excludeAuthor) model.author = APPLICATION_AUTHOR;
    if(!_excludeName) model.name = APPLICATION_NAME;
    if(!_excludeStartUri) model.startUri = APPLICATION_START_URI;
    if(!_excludeLanguage) model.language = APPLICATION_LANGUAGE;

    if(!_excludePages) {
      model.pages = new List<Page>();

      for(var i=0; i<PAGE_COUNT; i++) {
        model.pages.add(new Page(PAGE_TITLE, null)); //TODO create page mock
      }
    }

    if(!_excludeTasks) {
      model.tasks = new List<Task>();

      for(var i=0; i<TASK_COUNT; i++) {
        model.tasks.add(new Task()); //TODO create task mock
      }
    }

    if(!_excludeResources) {
      model.resources = new List<Resource>();

      for(var i=0; i<RESOURCE_COUNT; i++) {
        model.resources.add(new Resource()); //TODO create resource mock
      }
    }

    return new Future.value(model);
  }

}
