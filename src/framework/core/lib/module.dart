part of lib.core;

abstract class Module {
  Map<String, dynamic> config;
  String parentId;
  String id;

  const ID_PREFIX = "module";

  Module(this.parentId, this.config) {
    id = new UniqueUser(ID_PREFIX).getUniqueId();
    onInit(this.config);
  }

  /**
   *
   */
  void onInit(Map<String, dynamic> config);


}
