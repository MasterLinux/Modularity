part of lib.core;

abstract class Module {
  Map<String, dynamic> config;
  String fragmentId;
  String templateId;

  String _namespace;
  String _id;

  final String ID_PREFIX = "module";

  Module(this.fragmentId, this.config) {
    templateId = new UniqueId(ID_PREFIX).build();
    this.onInit(new InitEventArgs(this.config));
  }

  /**
   * Gets the namespace of the module
   */
  String get namespace => _namespace;

  /**
   * Gets the name of the module
   */
  String get id => _id; //TODO rename to name?

  void register(String namespace, String id) {
    _namespace = namespace;
    _id = id;

    //new ModuleManager(_namespace).register(this); TODO implement a function like this
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add(bool isNavigatedBack, Map<String, dynamic> parameter) {
    this.onBeforeAdd(new NavigationEventArgs(isNavigatedBack, parameter));

    //TODO add template to DOM

    this.onAdded();
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove(bool isNavigatedBack, Map<String, dynamic> parameter) {
    this.onBeforeRemove(new NavigationEventArgs(isNavigatedBack, parameter));

    //TODO remove template from DOM

    this.onRemoved();
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
  void monRequestCompleted(RequestCompletedEventArgs args) {

  }
}
