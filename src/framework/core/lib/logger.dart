part of lib.core;

class Logger {
  final List<MessageObserver> _observer = new List<MessageObserver>();
  final List<LoggingMessage> _messages = new List<LoggingMessage>();

  /**
   * Registers a new [observer] which will be notified
   * if a new message is received
   */
  void register(MessageObserver observer) {
    _observer.add(observer);
  }

  /**
   * Unregisters a specific [observer]
   */
  void unregister(MessageObserver observer) {
    _observer.remove(observer);
  }

  /**
   * Notifies each observer if a
   * [message] is received
   */
  void _notify(LoggingMessage message) {
    for(var observer in _observer) {
      observer(this, message);
    }
  }

  /**
   * Removes all logging
   * messages from stack
   */
  void clear() {
    _messages.clear();
  }

  /**
   * Gets all received warnings
   */
  void get warnings {
    return _messages.where((message) => message.level == Warning.LEVEL);
  }

  /**
   * Logs a warning [message]
   */
  void warning(Warning message) {
    _messages.add(message);
    _notify(message);
  }
}

/**
 * Interface for declaring classes as message observer
 */
class MessageObserver {
  onMessageReceived(Logger sender, LoggingMessage message);
  onMessagesCleared(Logger sender);
}

/**
 * Representation of a logging message
 */
abstract class LoggingMessage {
  final String namespace;
  DateTime _time;

  /**
   * Initializes the message with a [namespace] which
   * is usually the namespace and the name of the class,
   * like "lib.core.Logger".
   */
  LoggingMessage(this.namespace) {
    _time = new DateTime.now();
  }

  /**
   * Gets the time of tracking
   */
  DateTime get time {
    return _time;
  }

  /**
   * Gets the logging message
   */
  String get message;

  /**
   * Gets the message level
   */
  String get level;
}

/**
 * Representation of a warning
 */
abstract class Warning extends LoggingMessage {
  static final String LEVEL = "warning";

  Warning(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Warning which is used whenever a page already exists
 */
class PageExistsWarning extends Warning {
  final String uri;

  PageExistsWarning(String namespace, this.uri) : super(namespace);

  String get message {
    return "Page with URI => \"$uri\" already exists. The new one overrides the previous added page.";
  }
}

/**
 * Warning which is used whenever a background task already exists
 */
class BackgroundTaskExistsWarning extends Warning {
  final String id;

  BackgroundTaskExistsWarning(String namespace, this.id) : super(namespace);

  String get message {
    return "Task with ID => \"${id}\" already exists. The new one overrides the previous added task.";
  }
}

/**
 * Warning which is used whenever a resource already exists
 */
class ResourceExistsWarning extends Warning {
  final String name;

  ResourceExistsWarning(String namespace, this.name) : super(namespace);

  String get message {
    return "Resource with name => \"${name}\" already exists. The new one overrides the previous added resource.";
  }
}
