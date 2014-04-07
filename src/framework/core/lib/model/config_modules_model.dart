part of lib.core.model;

class ConfigModulesModel extends Model<ConfigModuleModel> {}

class ConfigModuleModel extends ObjectModel {
  String lib; //TODO rename?
  String name;
  Map<String, Object> config;
}
