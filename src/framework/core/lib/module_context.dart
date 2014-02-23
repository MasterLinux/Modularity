part of lib.core;

class ModuleContext {
  final AbstractModule module;

  ModuleContext(this.module);

  /**
   * Gets the parent page of the module which gives
   * for example access to the [NavigationEventArgs],
   * the title of the page or other information about
   * the page.
   */
  Page get page =>  module.page;

  /**
   * Gets the version of the module.
   */
  String get version => module.version;

  /**
   * Gets the name of the author of the module.
   */
  String get author => module.author;

  /**
   * Gets the company of the author of the module.
   */
  String get company => module.company;

  /**
   * Gets the website of the author of the module.
   */
  String get website => module.website;

  /**
   * Gets the e-mail address of the author of the module.
   */
  String get eMail => module.eMail;

  /**
   * Sends a message to other modules.
   */
  void send(String signal, SignalEventArgs args) {
    //emit signal
    Connect
      .signal(signal)
      .emit(args);
  }

  /**
   * Add slot to receive messages from other modules
   */
  void receive(String signal, Slot slot) {
    Connect
      .signal(signal)
      .to(slot);
  }

  //TODO add function for starting requests
}
