part of lib.core;

abstract class AbstractModule {
  final Map<String, dynamic> config;
  final String fragmentId;
  String _templateId;
  String _name;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "module";

  /**
   * Initializes the module
   */
  AbstractModule(this.fragmentId, this.config, { String name }) {
    _templateId = new UniqueId(ID_PREFIX).build();
    _name = name;

    onInit(new InitEventArgs(this.config));
  }

  /**
   * Gets the name of the module.
   */
  String get name {
    return _name;
  }

  /**
   * Gets the ID of the template of the module.
   */
  String get templateId {
    return _templateId;
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add(bool isNavigatedBack, Map<String, dynamic> parameter) {
    onBeforeAdd(new NavigationEventArgs(isNavigatedBack, parameter));

    //TODO add template to DOM

    onAdded();
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove(bool isNavigatedBack, Map<String, dynamic> parameter) {
    onBeforeRemove(new NavigationEventArgs(isNavigatedBack, parameter));

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
  void onBeforeAdd(NavigationEventArgs args) {
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
  void onBeforeRemove(NavigationEventArgs args) {
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
}
