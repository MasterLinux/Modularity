part of lib.core.model;

/**
 * Response model for applications
 */
class ConfigApplicationsModel extends Model<ConfigApplicationModel> {}

/**
 * Model which represents an appliaction
 */
class ConfigApplicationModel extends ObjectModel {
  String name;
  String version;
  String author;
  String defaultPage;
  //ConfigTextsModel texts; //TODO implement
  ConfigPagesModel pages;
  //ConfigTasksModel tasks; //TODO implement
}
