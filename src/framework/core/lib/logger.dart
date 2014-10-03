part of modularity.core;

class Logger {
  static const String NAMESPACE = "modularity.core.Logger";
  static const String DEFAULT_APPLICATION_VERSION = "0.0.0";
  static const String DEFAULT_APPLICATION_NAME = "undefined";
  final List<MessageObserver> _observer = new List<MessageObserver>();
  final List<LoggingMessage> messages = new List<LoggingMessage>();
  final String applicationVersion;
  final String applicationName;
  final bool isSynchronouslyModeEnabled;

  /**
   * Initializes the logger for a specific application
   * with its [applicationName] and [applicationVersion].
   * It is possible to enable synchronously mode so a [Logger.log] or
   * the call of [Logger.clear] is executed synchronously
   */
  Logger({this.applicationName: DEFAULT_APPLICATION_NAME,
         this.applicationVersion: DEFAULT_APPLICATION_VERSION,
         this.isSynchronouslyModeEnabled: false
         }) {
    if(applicationName == DEFAULT_APPLICATION_NAME ||
                          applicationName == null ||
                          applicationName.isEmpty) {
      log(new MissingApplicationNameError(NAMESPACE));
    }

    if(applicationVersion == DEFAULT_APPLICATION_VERSION ||
                             applicationVersion == null ||
                             applicationVersion.isEmpty) {
      log(new MissingApplicationVersionError(NAMESPACE));
    }
  }

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
  void _notifyMessagesCleared() {
    for(var observer in _observer) {
      observer.onMessagesCleared(this);
    }
  }

  void _clearSync() {
    messages.clear();
    _notifyMessagesCleared();
  }

  /**
   * Removes all logging
   * messages from stack
   */
  Future clear() {
    if(isSynchronouslyModeEnabled) {
        return new Future.sync(() => _clearSync());
    } else {
        Completer completer = new Completer();
        completer.complete();
        return completer.future.then((_) => _clearSync());
    }
  }

  /**
   * Gets all received warnings
   */
  List<WarningMessage> get warningMessages {
    return messages.where((message) => message.level == WarningMessage.LEVEL);
  }

  /**
   * Gets all received errors
   */
  List<ErrorMessage> get errorMessages {
    return messages.where((message) => message.level == ErrorMessage.LEVEL);
  }

  /**
   * Gets all received info messages
   */
  List<InfoMessage> get infoMessages {
    return messages.where((message) => message.level == InfoMessage.LEVEL);
  }

  /**
   * Gets all received lifecycle messages
   */
  List<LifecycleMessage> get lifecycleMessages {
    return messages.where((message) => message.level == LifecycleMessage.LEVEL);
  }

  /**
   * Gets all received network messages
   */
  List<NetworkMessage> get networkMessages {
    return messages.where((message) => message.level == NetworkMessage.LEVEL);
  }

  /**
   * Gets all received custom messages
   */
  List<NetworkMessage> get customMessages {
    return messages.where((message) => message.level == CustomMessage.LEVEL);
  }

  /**
   * Gets all received custom messages of a specific category
   */
  List<NetworkMessage> getCustomMessagesOfCategory(String category) {
    return messages.where((message) => message.level == CustomMessage.LEVEL && (message as CustomMessage).category == category);
  }

  void _logSync(LoggingMessage message) {
    messages.add(message);
    _notifyMessageReceived(message);
  }

  /**
   * Logs a [message]
   */
  Future log(LoggingMessage message) {
    if(isSynchronouslyModeEnabled) {
      return new Future.sync(() => _logSync(message));
    } else {
      Completer completer = new Completer();
      completer.complete();
      return completer.future.then((_) => _logSync(message));
    }
  }

  /**
   * Logs a warning [message]
   */
  Future logWarning(WarningMessage message) {
    return log(message);
  }

  /**
   * Logs an error [message]
   */
  Future logError(ErrorMessage message) {
    return log(message);
  }

  /**
   * Logs an info [message]
   */
  Future logInfo(InfoMessage message) {
    return log(message);
  }

  /**
   * Logs a lifecycle [message]
   */
  Future logLifecycle(LifecycleMessage message) {
    return log(message);
  }

  /**
   * Logs a network [message]
   */
  Future logNetwork(NetworkMessage message) {
    return log(message);
  }
}

/**
 * Interface for declaring classes as message observer
 */
class MessageObserver {
  void onMessageReceived(Logger sender, LoggingMessage message);
  void onMessagesCleared(Logger sender);
}

/**
 * Representation of a logging message
 */
abstract class LoggingMessage {
  final String namespace;
  DateTime _time;
  String _message;

  /**
   * Initializes the message with a [namespace] which
   * is usually the namespace and the name of the class,
   * like "modularity.core.Logger" and a [message].
   */
  LoggingMessage(this.namespace, [String message]) {
    _time = new DateTime.now();
    _message = message;
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
  String get message {
    return _message;
  }

  /**
   * Gets the message level
   */
  String get level;
}

/**
 * Representation of a custom message
 */
class CustomMessage extends LoggingMessage {
  static final String LEVEL = "custom";
  final String category;

  CustomMessage(String namespace, this.category, [String message]) : super(namespace, message);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of a warning
 */
class WarningMessage extends LoggingMessage {
  static final String LEVEL = "warning";

  WarningMessage(String namespace, [String message]) : super(namespace, message);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of an error
 */
class ErrorMessage extends LoggingMessage {
  static final String LEVEL = "error";

  ErrorMessage(String namespace, [String message]) : super(namespace, message);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of an info message
 */
class InfoMessage extends LoggingMessage {
  static final String LEVEL = "info";

  InfoMessage(String namespace, [String message]) : super(namespace, message);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of a lifecycle message
 */
class LifecycleMessage extends LoggingMessage {
  static final String LEVEL = "lifecycle";

  LifecycleMessage(String namespace, [String message]) : super(namespace, message);

  String get level {
    return LEVEL;
  }
}

/**
 * Representation of a network message
 */
class NetworkMessage extends LoggingMessage {
  static final String LEVEL = "network";

  NetworkMessage(String namespace, [String message]) : super(namespace, message);

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
    return "Task with ID => \"$id\" already exists. The new one overrides the previous added task.";
  }
}

/**
 * Warning which is used whenever a resource already exists
 */
class ResourceExistsWarning extends WarningMessage {
  final String name;

  ResourceExistsWarning(String namespace, this.name) : super(namespace);

  String get message {
    return "Resource with name => \"$name\" already exists. The new one overrides the previous added resource.";
  }
}

class MissingApplicationNameError extends ErrorMessage {
  MissingApplicationNameError(String namespace) : super(namespace);

  String get message {
    return "Application name is missing. You have to set a name to ensure that your application runs correctly.";
  }
}

class MissingApplicationVersionError extends ErrorMessage {
  MissingApplicationVersionError(String namespace) : super(namespace);

  String get message {
    return "Application version is missing. You have to set a version number to ensure that your application runs correctly.";
  }
}
