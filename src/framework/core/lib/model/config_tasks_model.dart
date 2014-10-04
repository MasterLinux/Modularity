part of modularity.core.model;

/**
 * Response model for tasks
 */
class ConfigTasksModel extends Model<ConfigTaskModel>{}

/**
 * Model which represents a task
 */
class ConfigTaskModel extends ObjectModel {
  String name;
  //TODO add flag which defines a behaviour?
}
