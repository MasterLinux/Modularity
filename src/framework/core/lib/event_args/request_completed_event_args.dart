part of lib.core;

class RequestCompletedEventArgs<T> extends EventArgs {
  final String requestId;
  final int statusCode;
  final bool isErrorOccurred;
  final T response;

  //TODO add response
  RequestCompletedEventArgs(this.requestId, this.statusCode, this.response, {this.isErrorOccurred: false});

}
