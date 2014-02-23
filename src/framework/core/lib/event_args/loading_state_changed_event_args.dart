part of lib.core;

class LoadingStateChangedEventArgs implements EventArgs {
  final bool isLoading;

  LoadingStateChangedEventArgs(this.isLoading);
}
