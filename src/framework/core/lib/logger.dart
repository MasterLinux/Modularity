part of lib.core;

class Logger {
  final List<MessageObserver> _observer = new List<MessageObserver>();
  final List<LoggingMessage> messages = new List<LoggingMessage>();
  final String applicationVersion;
  final String applicationName;

  /**
   * Initializes the logger for a specific application
   * with its [applicationName] and [applicationVersion]
   */
  Logger(this.applicationName, this.applicationVersion);

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
   * Notifies each observer that a
   * [message] is received
   */
  void _notifyMessageReceived(LoggingMessage message) {
    for(var observer in _observer) {
      observer.onMessageReceived(this, message);
    }
  }

  /**
   * Notifies each observer that all
   * messages are removed
   */
  void _notifyMessagesCleared(LoggingMessage message) {
    for(var observer in _observer) {
      observer.onMessagesCleared(this);
    }
  }

  /**
   * Removes all logging
   * messages from stack
   */
  void clear() {
    messages.clear();
  }

  /**
   * Gets all received warnings
   */
  void get warningMessages {
    return messages.where((message) => message.level == WarningMessage.LEVEL);
  }

  /**
   * Gets all received errors
   */
  void get errorMessages {
    return messages.where((message) => message.level == ErrorMessage.LEVEL);
  }

  /**
   * Gets all received info messages
   */
  void get infoMessages {
    return messages.where((message) => message.level == InfoMessage.LEVEL);
  }

  /**
   * Gets all received lifecycle messages
   */
  void get lifecycleMessages {
    return messages.where((message) => message.level == LifecycleMessage.LEVEL);
  }

  /**
   * Gets all received network messages
   */
  void get networkMessages {
    return messages.where((message) => message.level == NetworkMessage.LEVEL);
  }

  /**
   * Logs a [message]
   */
  void log(LoggingMessage message) {
    messages.add(message);
    _notifyMessageReceived(message);
  }

  /**
   * Logs a warning [message]
   */
  void logWarning(WarningMessage message) {
    log(message);
  }

  /**
   * Logs an error [message]
   */
  void logError(ErrorMessage message) {
    log(message);
  }

  /**
   * Logs an info [message]
   */
  void logInfo(InfoMessage message) {
    log(message);
  }

  /**
   * Logs a lifecycle [message]
   */
  void logLifecycle(LifecycleMessage message) {
    log(message);
  }

  /**
   * Logs a network [message]
   */
  void logNetwork(NetworkMessage message) {
    log(message);
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
abstract class WarningMessage extends LoggingMessage {
  static final String LEVEL = "warning";

  WarningMessage(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of an error
 */
abstract class ErrorMessage extends LoggingMessage {
  static final String LEVEL = "error";

  ErrorMessage(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of an info message
 */
abstract class InfoMessage extends LoggingMessage {
  static final String LEVEL = "info";

  InfoMessage(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of a lifecycle message
 */
abstract class LifecycleMessage extends LoggingMessage {
  static final String LEVEL = "lifecycle";

  LifecycleMessage(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of a network message
 */
abstract class NetworkMessage extends LoggingMessage {
  static final String LEVEL = "network";

  NetworkMessage(String namespace) : super(namespace);

  String get level {
    return LEVEL;
  }
}

/**
 * Warning which is used whenever a page already exists
 */
class PageExistsWarning extends WarningMessage {
  final String uri;

  PageExistsWarning(String namespace, this.uri) : super(namespace);

  String get message {
    return "Page with URI => \"$uri\" already exists. The new one overrides the previous added page.";
  }
}

/**
 * Warning which is used whenever a background task already exists
 */
class BackgroundTaskExistsWarning extends WarningMessage {
  final String id;

  BackgroundTaskExistsWarning(String namespace, this.id) : super(namespace);

  String get message {
    return "Task with ID => \"${id}\" already exists. The new one overrides the previous added task.";
  }
}

/**
 * Warning which is used whenever a resource already exists
 */
class ResourceExistsWarning extends WarningMessage {
  final String name;

  ResourceExistsWarning(String namespace, this.name) : super(namespace);

  String get message {
    return "Resource with name => \"${name}\" already exists. The new one overrides the previous added resource.";
  }
}
