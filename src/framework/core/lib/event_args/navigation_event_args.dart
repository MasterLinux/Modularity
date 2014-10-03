part of modularity.core.eventArgs;

class NavigationEventArgs implements EventArgs {
  final Map<String, dynamic> parameter;
  final bool isNavigatedBack;

  NavigationEventArgs(this.parameter, this.isNavigatedBack);
}
