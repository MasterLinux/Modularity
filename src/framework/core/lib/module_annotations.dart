part of lib.core;

class Module {
  final String namespace;
  final String name;

  const Module(this.namespace, this.name);
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
 *     @OnInit
 *     void init(InitEventArgs args) {
 *         //do something important
 *     }
 *
 */
const Object OnInit = const _OnInit();

class _OnInit {
  const _OnInit();
}

/**
 * Annotation which marks a function
 * as
 */
const Object OnBeforeAdd = const _OnBeforeAdd();

class _OnBeforeAdd {
  const _OnBeforeAdd();
}

const Object OnAdded = const _OnAdded();

class _OnAdded {
  const _OnAdded();
}

const Object OnBeforeRemove = const _OnBeforeRemove();

class _OnBeforeRemove {
  const _OnBeforeRemove();
}

const Object OnRemoved = const _OnRemoved();

class _OnRemoved {
  const _OnRemoved();
}

class OnRequestCompleted {
  final String requestId;
  final bool isErrorHandler;

  const OnRequestCompleted([this.requestId, this.isErrorHandler = false]);

  bool get isDefault {
    return requestId == null;
  }
}