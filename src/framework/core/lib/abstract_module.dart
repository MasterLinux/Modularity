part of lib.core;

abstract class AbstractModule {
  final Map<String, Object> config;
  final Fragment fragment;
  ModuleContext _context;
  String _uniqueId;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "module";

  /**
   * Initializes the module.
   */
  AbstractModule(this.fragment, this.config) {
    _uniqueId = new UniqueId(ID_PREFIX).build();
    _context = new ModuleContext(this);

    onInit(new InitEventArgs(this.config));
  }

  /**
   * Gets the name of the module.
   */
  String get name;

  /**
   * Gets the library of the module.
   */
  String get lib;

  /**
   * Gets the version of the module.
   */
  String get version;

  /**
   * Gets the unique ID of the module.
   * Each instance of a module has
   * its own unique ID.
   */
  String get uniqueId {
    return _uniqueId;
  }

  /**
   * Gets the module context, used
   * to get the current displayed
   * page and to communicate with
   * other modules.
   */
  ModuleContext get context {
    return _context;
  }

  /**
   * Gets the company of the author of the module.
   */
  String get company => null;

  /**
   * Gets the e-mail address of the author of the module.
   */
  String get eMail => null;

  /**
   * Gets the website of the author of the module.
   */
  String get website => null;

  /**
   * Gets the name of the author of the module.
   */
  String get author => null;

  /**
   * Adds the template of the module to DOM.
   */
  void add() {
    onBeforeAdd();

    //TODO add template to DOM

    onAdded();
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove() {
    onBeforeRemove();

    //TODO remove template from DOM

    onRemoved();
  }

  /**
   * This init function is called once when the module
   * is initialized on app start.
   */
  void onInit(InitEventArgs args);

  /**
   * This event handler is invoked when the module will be created,
   * but before the template of the module is added to the DOM.
   */
  void onBeforeAdd() {
    //does nothing, but can be overridden to handle this event
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded() {
    //does nothing, but can be overridden to handle this event
  }

  /**
   * This event handler is invoked when the module
   * will be destroyed but before the template
   * is removed from DOM.
   */
  void onBeforeRemove() {
    //does nothing, but can be overridden to handle this event
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved() {
    //does nothing, but can be overridden to handle this event
  }

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args) {
    //does nothing, but can be overridden to handle this event
  }

  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {

  }
}
