part of lib.core;

class module {
  final String namespace;
  final String name;

  const module(this.namespace, this.name);
}

/**
 * Annotation which marks a function
 * as init function of a module. A module
 * must be contain one init function(s).
 * In addition an init function is just
 * invoked once when the module is initialized
 * on application start.
 *
 * example usage:
 *
 *     @onInit
 *     void init(InitEventArgs args) {
 *         //do something important
 *     }
 *
 */
const Object onInit = const _OnInit();

class _OnInit {
  const _OnInit();
}

/**
 * Annotation which marks a function
 * as
 */
class onBeforeAdd {
  const onBeforeAdd();
}

class onAdded {
  const onAdded();
}

class onBeforeRemove {
  const onBeforeRemove();
}

class onRemoved {
  const onRemoved();
}

class onRequestCompleted {
  String requestId;
  bool isErrorHandler;

  const String DEFAULT_REQUEST_ID = "_[default_request]_"; //TODO find prefixed ID? to avoid unexpected overrides

  const onRequestCompleted({this.requestId: DEFAULT_REQUEST_ID, this.isErrorHandler: false});

  bool get isDefault {
    return DEFAULT_REQUEST_ID == requestId;
  }
}