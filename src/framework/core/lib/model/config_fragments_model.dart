part of lib.core.model;

class ConfigFragmentsModel extends Model<ConfigFragmentModel> {}

class ConfigFragmentModel extends ObjectModel {
  String title;
  String parent;
  ConfigModulesModel modules;
}
