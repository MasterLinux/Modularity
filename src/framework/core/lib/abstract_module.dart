part of lib.core;

abstract class AbstractModule {
  final Map<String, Object> config;
  final String fragmentId;
  ModuleContext _context;
  String _templateId;
  String _id;

  //author info
  String _author;
  String _company;
  String _eMail;
  String _website;
  String _version;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "module";

  /**
   * Initializes the module
   */
  AbstractModule(this.fragmentId, this.config, { String id }) { //TODO id required?
    _templateId = new UniqueId(ID_PREFIX).build();
    _context = new ModuleContext(this);
    _id = id;

    onInit(new InitEventArgs(this.config));
  }

  /**
   * Gets the name of the module.
   */
  String get id {
    return _id;
  }

  /**
   * Gets the ID of the template of the module.
   */
  String get templateId {
    return _templateId;
  }

  /**
   * Gets the parent page of the module.
   */
  Page get page {
    return null; //TODO implement
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

  String get company => _company;

  String get eMail => _eMail;

  String get website => _website;

  String get version => _version;

  String get author => _author;

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
