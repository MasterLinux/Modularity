part of modularity.core.eventArgs;

class NavigationEventArgs implements EventArgs {
  final HashMap<String, dynamic> parameter;
  final bool isNavigatedBack;

  NavigationEventArgs({this.parameter: new HashMap<String, dynamic>(), this.isNavigatedBack: false});
}
