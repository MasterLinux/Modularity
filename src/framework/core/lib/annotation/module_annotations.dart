part of lib.core;

/**
 * Annotation which marks a class as module.
 */
class Module {
  final String author;
  final String company;
  final String eMail;
  final String website;
  final String version;

  const Module(this.version, {this.author, this.company, this.eMail, this.website});
}

/**
 * Annotation which marks a function
 * as init function of a module. A module
 * must be contain one init function.
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

class OnLoadingStateChanged {
  final bool isLoading;

  const OnLoadingStateChanged({this.isLoading});

  bool get isDefault => isLoading == null;
}

class OnRequestCompleted {
  final String requestId;
  final bool isErrorHandler;

  const OnRequestCompleted([this.requestId, this.isErrorHandler = false]);

  bool get isDefault => requestId == null;
}