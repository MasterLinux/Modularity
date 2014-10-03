part of modularity.core.model;

class ConfigModulesModel extends Model<ConfigModuleModel> {}

/**
 * Config model which represents a module
 */
class ConfigModuleModel extends ObjectModel {

  /**
   * Name of the library which contains the
   * required module
   */
  String lib;

  /**
   * Name of the module to load
   */
  String name;

  /**
   * Config to setup the loaded
   * module
   */
  Map<String, Object> config;
}
