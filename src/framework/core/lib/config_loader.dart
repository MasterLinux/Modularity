part of lib.core;

/**
 * Application data model which contains
 * each information to initialize an app
 */
class ApplicationData {
  List<Task> tasks;
  List<Resource> resources;
  List<Page> pages;
  String name;
  String version;
  String language;
  String startUri;
  String author;
}

/**
 * Interface which represents an
 * application config loader
 */
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
