library modularity.core.logging;

class Logger {
  final List<MessageObserver> _observer = new List<MessageObserver>();
  final List<LoggingMessage> messages = new List<LoggingMessage>();
  static Map<String, Logger> _cache;
  final String applicationName;
  final String applicationVersion;

  static const String namespace = "modularity.core.Logger";

  //all available level
  static const String customLevel = "custom";
  static const String errorLevel = "error";
  static const String warningLevel = "warning";
  static const String lifecycleLevel = "lifecycle";
  static const String infoLevel = "info";
  static const String networkLevel = "network";

  /**
   * Initializes a logger for a specific application
   */
  factory Logger(String applicationName, String applicationVersion) {
    var key = "${applicationName}_${applicationVersion}";

    if(_cache == null) {
      _cache = {};
    }

    if(_cache.containsKey(key)) {
      return _cache[key];
    } else {
      final logger = new Logger._internal(applicationName, applicationVersion);
      _cache[key] = logger;
      return logger;
    }
  }

  Logger._internal(this.applicationName, this.applicationVersion);

  /**
   * Registers a new [observer] which will be notified
   * if a new message is received
   */
  void register(MessageObserver observer) => _observer.add(observer);

  /**
   * Unregisters a specific [observer]
   */
  bool unregister(MessageObserver observer) => _observer.remove(observer);

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

  /**
   * Removes all logging
   * messages from logger
   */
  void clear() {
    messages.clear();
    _notifyMessagesCleared();
  }

  /**
   * Add a [message] to the logger to track
   * a specific action, event, etc.
   */
  void log(LoggingMessage message) {
    messages.add(message);
    _notifyMessageReceived(message);
  }

  /**
   * Gets all received warnings
   */
  List<WarningMessage> get warningMessages => messages.where((message) => message.level == warningLevel);

  /**
   * Gets all received errors
   */
  List<ErrorMessage> get errorMessages => messages.where((message) => message.level == errorLevel);

  /**
   * Gets all received info messages
   */
  List<InfoMessage> get infoMessages => messages.where((message) => message.level == infoLevel);

  /**
   * Gets all received lifecycle messages
   */
  List<LifecycleMessage> get lifecycleMessages => messages.where((message) => message.level == lifecycleLevel);

  /**
   * Gets all received network messages
   */
  List<NetworkMessage> get networkMessages => messages.where((message) => message.level == networkLevel);

  /**
   * Gets all received custom messages
   */
  List<NetworkMessage> get customMessages => messages.where((message) => message.level == customLevel);

  /**
   * Gets all received custom messages of a specific category
   */
  List<NetworkMessage> getCustomMessagesOfCategory(String category) {
    return messages.where(
      (message) => message.level == customLevel && (message as CustomMessage).category == category
    );
  }
}

/**
 * Interface for declaring classes as message observer
 */
abstract class MessageObserver {
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
  final String category;

  CustomMessage(String namespace, this.category, [String message]) : super(namespace, message);

  String get level => Logger.customLevel;
}

/**
 * Representation of a warning
 */
class WarningMessage extends LoggingMessage {
  WarningMessage(String namespace, [String message]) : super(namespace, message);

  String get level => Logger.warningLevel;
}

/**
 * Representation of an error
 */
class ErrorMessage extends LoggingMessage {
  ErrorMessage(String namespace, [String message]) : super(namespace, message);

  String get level => Logger.errorLevel;
}

/**
 * Representation of an info message
 */
class InfoMessage extends LoggingMessage {
  InfoMessage(String namespace, [String message]) : super(namespace, message);

  String get level => Logger.infoLevel;
}

/**
 * Representation of a lifecycle message
 */
class LifecycleMessage extends LoggingMessage {
  LifecycleMessage(String namespace, [String message]) : super(namespace, message);

  String get level => Logger.lifecycleLevel;
}

/**
 * Representation of a network message
 */
class NetworkMessage extends LoggingMessage {
  NetworkMessage(String namespace, [String message]) : super(namespace, message);

  String get level => Logger.networkLevel;
}

/**
 * Warning which is used whenever a page already exists
 */
class PageExistsWarning extends WarningMessage {
  final String _uri;

  PageExistsWarning(String namespace, String uri) : _uri = uri, super(namespace);

  @override
  String get message =>
      "Page with URI => \"$_uri\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}

class MissingPageWarning extends WarningMessage {
  final String _uri;

  MissingPageWarning(String namespace, String uri) : _uri = uri, super(namespace);

  @override
  String get message =>
  "Page with URI => \"$_uri\" does not exists. Please check whether a page with this URI is registered.";
}

/**
 * Warning which is used whenever a background task already exists
 */
class TaskExistsWarning extends WarningMessage {
  final String _id;

  TaskExistsWarning(String namespace, String id) : _id = id, super(namespace);

  @override
  String get message =>
      "Task with ID => \"$_id\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}

/**
 * Warning which is used whenever a resource already exists
 */
class ResourceExistsWarning extends WarningMessage {
  final String _name;

  ResourceExistsWarning(String namespace, String name) : _name = name, super(namespace);

  @override
  String get message =>
      "Resource with name => \"$_name\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}

/// Warning which is used whenever a fragment is already added
class FragmentExistsWarning extends WarningMessage {
  final String _uri;
  final String _id;

  FragmentExistsWarning(String namespace, String pageUri, String fragmentId) : _id = fragmentId, _uri = pageUri, super(namespace);

  @override
  String get message =>
      "Fragment with ID => \"$_id\" is already added to page with URI => \"$_uri\". You have to fix the duplicate to ensure that the application works as expected.";
}

class ModuleExistsWarning extends WarningMessage {
  final String _fragmentId;
  final String _moduleId;

  ModuleExistsWarning(String namespace, String moduleId, String fragmentId) : _fragmentId = fragmentId, _moduleId = moduleId, super(namespace);

  @override
  String get message =>
      "Module with ID => \"$_moduleId\" is already added to fragment with ID => \"$_fragmentId\". You have to fix the duplicate to ensure that the application works as expected.";
}

class ParameterExistsWarning extends WarningMessage {
  final String _name;

  ParameterExistsWarning(String namespace, String name) : _name = name, super(namespace);

  @override
  String get message =>
      "Parameter with name => \"$_name\" already exists. You have to fix the duplicate to ensure that the application works as expected.";
}

class MissingDefaultLanguageWarning extends WarningMessage {
  MissingDefaultLanguageWarning(String namespace) : super(namespace);

  @override
  String get message =>
      "Application Language is not set. So it will be fall back to the default language.";
}

class MissingParameterWarning extends WarningMessage {
  final String _name;
  final String _uri;

  MissingParameterWarning(String namespace, String uri, String name) : _name = name, _uri = uri, super(namespace);

  @override
  String get message =>
      "Parameter with name => \"$_name\" is missing. Check whether the given parameter name for page with URI => \"$_uri\" is correct.";
}

class MissingApplicationNameError extends ErrorMessage {
  MissingApplicationNameError(String namespace) : super(namespace);

  @override
  String get message =>
      "Application name is missing. You have to set a name to ensure that your application runs correctly.";
}

class MissingApplicationVersionError extends ErrorMessage {
  MissingApplicationVersionError(String namespace) : super(namespace);

  @override
  String get message =>
      "Application version is missing. You have to set a version number to ensure that your application runs correctly.";
}

class MissingStartUriError extends ErrorMessage {
  MissingStartUriError(String namespace) : super(namespace);

  @override
  String get message =>
      "Start URI is missing. You have to set a start URI or have to add a page to ensure that your application runs correctly.";
}
