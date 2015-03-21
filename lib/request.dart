part of modularity.core;

/**
 * The [@OnLoadingStateChanged] annotation is used to mark a function
 * as event handler for the onLoadingStateChanged event of a module.
 *
 * example usage:
 *
 *     //is invoked when the app starts and stops to load
 *     @OnLoadingStateChanged()
 *     void onLoadingStateChangedEventHandler(LoadingStateChangedEventArgs args) { ... }
 *
 *     //is just invoked when the app starts to load
 *     @OnLoadingStateChanged(isLoading: true)
 *     void onLoadingStartedEventHandler(LoadingStateChangedEventArgs args) { ... }
 *
 *     //is just invoked when the app stops to load
 *     @OnLoadingStateChanged(isLoading: false)
 *     void onLoadingStoppedEventHandler(LoadingStateChangedEventArgs args) { ... }
 *
 */
class OnLoadingStateChanged {

  /**
   * Flag which indicates whether the function marked with this
   * annotation is used as error handler or not.
   */
  final bool isLoading;

  /**
   * Initializes the [@OnLoadingStateChanged] annotation.
   */
  const OnLoadingStateChanged({this.isLoading});

  /**
   * Flag which indicates whether the function
   * is used as default event handler, so the function
   * is invoked whenever the application starts and stops to load.
   */
  bool get isDefault => isLoading == null;

  bool isExecutable(LoadingStateChangedEventArgs args) => isLoading == args.isLoading || isDefault;
}

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
class OnRequestCompleted { //TODO move to requests library

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

  bool isExecutable(RequestCompletedEventArgs args) {
    return (requestId == args.requestId && isErrorHandler == args.isErrorOccurred) || isDefault;
  }
}