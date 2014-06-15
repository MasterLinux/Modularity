part of modularity.tests.mock;

class ConfigLoaderMock extends ConfigLoader {
  static String APPLICATION_NAME = "App Title";
  static String APPLICATION_VERSION = "App Title";
  static String APPLICATION_LANGUAGE = "App Title";
  static String APPLICATION_START_URI = "App Title";
  static String APPLICATION_AUTHOR = "App Title";
  static int PAGE_COUNT = 2;
  static String PAGE_TITLE = "Page Title";

  bool get isLoaded {
    return true;
  }

  Future<ApplicationData> load() {
    var model = new ApplicationData();
    model.name = APPLICATION_NAME;
    model.version = APPLICATION_VERSION;
    model.language = APPLICATION_LANGUAGE;
    model.startUri = APPLICATION_START_URI;
    model.author = APPLICATION_AUTHOR;

    //add pages
    model.pages = new List<Page>();

    for(var i=0; i<PAGE_COUNT; i++) {
      model.pages.add(new Page(PAGE_TITLE, null)); //TODO create page mock
    }

    return new Future.value(model);
  }

}
