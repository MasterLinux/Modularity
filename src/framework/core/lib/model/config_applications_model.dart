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
  ConfigApplicationDefaultModel defaults; //TODO rename?
  //ConfigTextsModel texts; //TODO implement
  ConfigPagesModel pages;
  //ConfigTasksModel tasks; //TODO implement
}

class ConfigApplicationDefaultModel {
  String fragment;
  String page;
}
