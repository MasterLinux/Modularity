part of lib.core.annotation.module;

/**
 * The [@OnRequestCompleted] annotation is used to mark a function
 * as event handler for the onRequestCompleted event of a module.
 *
 * example usage:
 *
 *     //Is invoked when any request is completed with and without error
 *     @OnRequestCompleted()
 *     void onRequestCompletedEventHandler(RequestCompletedEventArgs args) { ... }
 *
 *     //Is invoked when the request with the ID "news" is completed without error
 *     @OnRequestCompleted(requestId: "news")
 *     void onNewsRequestCompletedEventHandler(RequestCompletedEventArgs args) { ... }
 *
 *     //Is invoked when the request with the ID "news" is completed with error
 *     @OnRequestCompleted(requestId: "news", isErrorHandler: true)
 *     void onNewsRequestErrorEventHandler(RequestCompletedEventArgs args) { ... }
 *
 */
class OnRequestCompleted {
  final String requestId;
  final bool isErrorHandler;

  const OnRequestCompleted({this.requestId, this.isErrorHandler: false});

  bool get isDefault => requestId == null;
}
