part of modularity.core.eventArgs;

class NavigationEventArgs implements EventArgs {
  final HashMap<String, dynamic> parameter; //TODO do not use dynamic
  final bool isNavigatedBack;
  final String uri;

  NavigationEventArgs(this.uri, {
    this.parameter: new HashMap<String, dynamic>(),
    this.isNavigatedBack: false
  });
}
