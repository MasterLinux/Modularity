part of lib.core;

class InitEventArgs implements EventArgs {
  final Map<String, dynamic> config;

  InitEventArgs(this.config);
}
