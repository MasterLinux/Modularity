part of modularity.core.eventArgs;

class RequestCompletedEventArgs<T> implements EventArgs {
  final String requestId;
  final int statusCode;
  final bool isErrorOccurred;
  final T response;

  //TODO add response
  RequestCompletedEventArgs(this.requestId, this.statusCode, this.response, {this.isErrorOccurred: false});

}
