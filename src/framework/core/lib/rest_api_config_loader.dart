part of lib.core;

/**
 * typedef to allow dependency injection
 * for injecting a config loader into
 * an application
 */
typedef ConfigLoader ConfigLoaderFactory();

/**
 * The default config loader used whenever
 * no custom loader is injected
 */
ConfigLoader _defaultConfigLoader() => new RestApiConfigLoader();

class RestApiConfigLoader extends ConfigLoader {
  bool _isLoaded;
  final Uri uri;

  RestApiConfigLoader.fromUri(this.uri);

  Future<ApplicationInfo> load() {
    //TODO implement
  }

  bool get isLoaded {
    return _isLoaded;
  }


}
