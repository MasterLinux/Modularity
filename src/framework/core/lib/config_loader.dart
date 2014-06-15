part of lib.core;

class ApplicationData { //TODO rename model
  //List<Task> tasks;
  //List<Resource> resources;
  List<Page> pages;
  String name;
  String version;
  String language;
  String startUri;
  String author;
}

abstract class ConfigLoader {

  /**
   * Flag which indicates whether the config
   * is already loaded or not
   */
  bool get isLoaded;

  /**
   * Loads the config asynchronously
   */
  Future<ApplicationData> load();
}
