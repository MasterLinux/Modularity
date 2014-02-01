part of lib.core;

class Config {
  Uri _applicationsUri;
  Uri _pagesUri;
  Uri _fragmentsUri;
  Uri _modulesUri;
  Uri _textsUri;

  const _RESOURCE_APPLICATIONS = "/applications";
  const _RESOURCE_PAGES = "/pages";
  const _RESOURCE_FRAGMENTS = "/fragments";
  const _RESOURCE_MODULES = "/modules";
  const _RESOURCE_TEXTS = "/texts";

  /**
   * initializes the config with
   * the help of the servers [baseUrl]
   */
  Config(int applicationId, {String scheme: 'https', String baseUrl: '127.0.0.1' }) {
    //create URIs for getting the config
    _applicationsUri = new Uri(
      path: _RESOURCE_APPLICATIONS,
      scheme: scheme,
      host: baseUrl
    );

    _pagesUri = new Uri(
        path: _RESOURCE_PAGES,
        scheme: scheme,
        host: baseUrl
    );

    _fragmentsUri = new Uri(
        path: _RESOURCE_FRAGMENTS,
        scheme: scheme,
        host: baseUrl
    );

    _modulesUri = new Uri(
        path: _RESOURCE_MODULES,
        scheme: scheme,
        host: baseUrl
    );

    _textsUri = new Uri(
        path: _RESOURCE_PAGES,
        scheme: scheme,
        host: baseUrl
    );
  }

  void getConfig() {
    var applicationsRequest = HttpRequest.getString(_applicationsUri.toString());
    var pagesRequest = HttpRequest.getString(_pagesUri.toString());
    var fragmentsRequest = HttpRequest.getString(_fragmentsUri.toString());
    var modulesRequest = HttpRequest.getString(_modulesUri.toString());
    var textsRequest = HttpRequest.getString(_textsUri.toString());

    //wait for completing all requests
    Future.wait([
      applicationsRequest,
      pagesRequest,
      fragmentsRequest,
      modulesRequest,
      textsRequest
    ]).then((List requests) {

    });

  }
}
