part of lib.core.eventArgs;

class InitEventArgs implements EventArgs {
  final Map<String, Object> config;

  InitEventArgs(this.config);
}
