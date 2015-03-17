part of modularity.core.data;

/**
 * Marker interface for representing
 * a model which provides event data.
 */
abstract class EventArgs { }

class InitEventArgs implements EventArgs { //TODO move to module.dart
  final Map<String, Object> config;

  InitEventArgs(this.config);
}

class LoadingStateChangedEventArgs implements EventArgs {  //TODO move to module.dart
  final bool isLoading;

  LoadingStateChangedEventArgs(this.isLoading);
}

class RequestCompletedEventArgs<T> implements EventArgs {  //TODO move to module.dart
  final String requestId;
  final int statusCode;
  final bool isErrorOccurred;
  final T response;

  //TODO add response
  RequestCompletedEventArgs(this.requestId, this.statusCode, this.response, {this.isErrorOccurred: false});

}
