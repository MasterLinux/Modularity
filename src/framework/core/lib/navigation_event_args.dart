part of lib.core;

class NavigationEventArgs extends EventArgs {
  Map<String, dynamic> parameter;
  bool isNavigatedBack;

  NavigationEventArgs(this.parameter, this.isNavigatedBack);
}
