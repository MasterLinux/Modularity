part of modularity.core;

class Task {
  final String name;

  Task(this.name);
}

/**
 * Warning which is used whenever a background task already exists
 */
class TaskExistsWarning extends utility.WarningMessage {
  final String _id;

  TaskExistsWarning(String namespace, String id) : _id = id, super(namespace);

  @override
  String get message =>
  "Task with ID => \"$_id\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}
