part of modularity.core.eventArgs;

class LoadingStateChangedEventArgs implements EventArgs {
  final bool isLoading;

  LoadingStateChangedEventArgs(this.isLoading);
}
