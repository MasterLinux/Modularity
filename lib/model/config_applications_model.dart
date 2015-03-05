part of modularity.core.model;

/**
 * Response model for applications
 */
class ConfigApplicationsModel extends Model<ConfigApplicationModel> {}

/**
 * Model which represents an application
 */
class ConfigApplicationModel extends ObjectModel {
  String name;
  String version;
  String author;
  String startUri;
  String defaultLanguage;
  ConfigResourcesModel resources;
  ConfigPagesModel pages;
  //ConfigTasksModel tasks; //TODO implement
}

