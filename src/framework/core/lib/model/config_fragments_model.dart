part of modularity.core.model;

class ConfigFragmentsModel extends Model<ConfigFragmentModel> {}

class ConfigFragmentModel extends ObjectModel {

  /**
   * The ID of the parent node in which
   * this fragment is placed
   */
  String parentId;

  /**
   * All contained modules of the fragment
   */
  ConfigModulesModel modules;
}
