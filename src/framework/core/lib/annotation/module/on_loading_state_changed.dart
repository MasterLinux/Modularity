part of lib.core.annotation.module;

/**
 * The [@OnLoadingStateChanged] annotation is used to mark a function
 * as event handler for the onLoadingStateChanged event of a module.
 *
 * example usage:
 *
 *     //is invoked when the app starts or stops to load
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
  final bool isLoading;

  const OnLoadingStateChanged({this.isLoading});

  bool get isDefault => isLoading == null;
}
