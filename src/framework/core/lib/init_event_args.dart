part of lib.core;

class InitEventArgs extends EventArgs {
  final Map<String, dynamic> config;

  InitEventArgs(this.config);
}
