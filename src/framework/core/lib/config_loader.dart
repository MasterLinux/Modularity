part of modularity.core;

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
  Future<ApplicationInfo> load();
}
