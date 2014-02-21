part of lib.core;

class ModuleContext {
  final AbstractModule module;

  ModuleContext(this.module);

  Page get page {
    return module.page;
  }

  /**
   * Sends a message to other modules
   */
  void sendMessage(String signal, SignalEventArgs args) {
    //emit signal
    Connect
      .signal(signal)
      .emit(args);
  }
}
