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
const Object onBeforeAdd = const _OnBeforeAdd();

class _OnBeforeAdd {
  const _OnBeforeAdd();
}

const Object onAdded = const _OnAdded();

class _OnAdded {
  const _OnAdded();
}

const Object onBeforeRemove = const _OnBeforeRemove();

class _OnBeforeRemove {
  const _OnBeforeRemove();
}

const Object onRemoved = const _OnRemoved();

class _OnRemoved {
  const _OnRemoved();
}

class onRequestCompleted {
  final String requestId;
  final bool isErrorHandler;

  const onRequestCompleted([this.requestId, this.isErrorHandler = false]);

  bool get isDefault {
    return requestId == null;
  }
}