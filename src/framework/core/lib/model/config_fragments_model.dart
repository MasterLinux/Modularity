part of modularity.core.model;

class ConfigFragmentsModel extends Model<ConfigFragmentModel> {}

class ConfigFragmentModel extends ObjectModel {

  /**
   * Optional fragment title
   */
  String title;

  /**
   *
   */
  String parent;


  ConfigModulesModel modules;
}
