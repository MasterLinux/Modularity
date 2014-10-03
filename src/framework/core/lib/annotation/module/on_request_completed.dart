part of modularity.core.annotation.module;

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

  /**
   * ID of the request to listen for completion.
   */
  final String requestId;

  /**
   * Flag which indicates whether the function marked with this annotation
   * is used as error handler or not.
   */
  final bool isErrorHandler;

  /**
   * Initializes the [@OnRequestCompleted] annotation.
   */
  const OnRequestCompleted({this.requestId, this.isErrorHandler: false});

  /**
   * Flag which indicates whether the function marked with this annotation
   * is a default handler which is invoked whenever the request is
   * completed with and without error.
   */
  bool get isDefault => requestId == null;
}
