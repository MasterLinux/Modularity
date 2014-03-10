part of lib.core.model;

/**
 * Response model for pages
 */
class ConfigPagesModel extends Model<ConfigPageModel>{}

/**
 * Model which represents a page
 */
class ConfigPageModel extends ObjectModel {
  String uri;
  String title;
  ConfigFragmentsModel fragments;
}
