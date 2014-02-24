part of lib.core.annotation.module;

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
}
