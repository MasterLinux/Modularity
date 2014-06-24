part of lib.core;

class RestApiConfigLoader extends ConfigLoader {
  bool _isLoaded;
  final Uri uri;

  RestApiConfigLoader.fromUri(this.uri);

  Future<ApplicationData> load() {
    //TODO implement
  }

  bool get isLoaded {
    return _isLoaded;
  }


}
