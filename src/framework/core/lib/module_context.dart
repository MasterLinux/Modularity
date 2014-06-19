part of lib.core;

/**
 * The context of a module which contains all information
 * about the module. Furthermore it is used to communicate
 * with another modules.
 */
class ModuleContext {
  final AbstractModule module;

  /**
   * Initializes the module context.
   */
  ModuleContext(this.module);

  /**
   * Gets the parent page of the module which gives
   * for example access to the [NavigationEventArgs],
   * the title of the page or other information about
   * the page.
   */
  Page get page =>  module.fragment.page;

  /**
   * Gets the parent fragment of the module.
   */
  Fragment get fragment => module.fragment;

  /**
   * Gets the whole application
   */
  Application get application => null; //TODO implement, or just return the meta information about the application?

  /**
   * Gets the name of the module.
   */
  String get name => module.name;

  /**
   * Gets the library name of the module.
   */
  String get lib => module.lib;

  /**
   * Gets the version number of the module.
   */
  String get version => module.meta.version;

  /**
   * Gets the name of the author of the module.
   */
  String get author => module.meta.author;

  /**
   * Gets the company of the author of the module.
   */
  String get company => module.meta.company;

  /**
   * Gets the website of the author of the module.
   */
  String get website => module.meta.website;

  /**
   * Gets the e-mail address of the author of the module.
   */
  String get eMail => module.meta.eMail;

  /**
   * Sends a message to other modules.
   * //TODO comment return Future
   */
  Future send(String signal, SignalEventArgs args) {
    //emit signal
    return Connect
      .signal(signal)
      .emit(args);
  }

  /**
   * Add slot to receive messages from other modules
   */
  void listen(String signal, Slot slot) {
    Connect
      .signal(signal)
      .to(slot);
  }

  //TODO add function for starting requests?
}
