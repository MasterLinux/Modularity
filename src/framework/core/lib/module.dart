part of lib.core;

abstract class Module {
  Map<String, dynamic> config;
  String fragmentId;
  String id;

  const ID_PREFIX = "module";

  Module(this.fragmentId, this.config) {
    id = new UniqueId(ID_PREFIX).build();
    onInit(this.config);
  }

  void create(bool isNavigatedBack, Map<String, dynamic> parameter) {
    onNavigatedTo(new NavigationEventArgs(isNavigatedBack, parameter));

    //TODO insert template to DOM

    onReady();
  }

  void destroy() {

  }

  /**
   * This init function is called once when the module
   * is initialized by the module loader.
   */
  void onInit(Map<String, dynamic> config);

  void onNavigatedTo(NavigationEventArgs args) {
    //does nothing, but can be overridden
  }

  void onReady() {

  }
}
