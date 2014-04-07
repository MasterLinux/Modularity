part of lib.core;

class ModuleContext {
  final AbstractModule _module;

  /**
   * Initializes the module context.
   */
  ModuleContext(this._module);

  /**
   * Gets the parent page of the module which gives
   * for example access to the [NavigationEventArgs],
   * the title of the page or other information about
   * the page.
   */
  Page get page =>  _module.fragment.page;

  /**
   * Gets the parent fragment of the module.
   */
  Fragment get fragment => _module.fragment;

  /**
   * Gets the name of the module.
   */
  String get name => _module.name;

  /**
   * Gets the library of the module.
   */
  String get lib => _module.lib;

  /**
   * Gets the version of the module.
   */
  String get version => _module.version;

  /**
   * Gets the name of the author of the module.
   */
  String get author => _module.author;

  /**
   * Gets the company of the author of the module.
   */
  String get company => _module.company;

  /**
   * Gets the website of the author of the module.
   */
  String get website => _module.website;

  /**
   * Gets the e-mail address of the author of the module.
   */
  String get eMail => _module.eMail;

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

  //TODO add function for starting requests
}
