part of lib.core.annotation.module;

/**
 * The [@OnBeforeRemove] annotation is used to mark a function
 * as event handler for the onBeforeRemove event of a module.
 *
 * example usage:
 *
 *     @OnBeforeRemove
 *     void onBeforeRemoveEventHandler() { ... }
 *
 */
const Object OnBeforeRemove = const OnBeforeRemoveAnnotation();

class OnBeforeRemoveAnnotation {
  const OnBeforeRemoveAnnotation();
}
