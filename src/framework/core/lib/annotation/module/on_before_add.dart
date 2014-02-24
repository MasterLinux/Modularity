part of lib.core.annotation.module;

/**
 * The [@OnBeforeAdd] annotation is used to mark a function
 * as event handler for the onBeforeAdd event of a module.
 *
 * example usage:
 *
 *     @OnBeforeAdd
 *     void onBeforeAddEventHandler() { ... }
 *
 */
const Object OnBeforeAdd = const OnBeforeAddAnnotation();

class OnBeforeAddAnnotation {
  const OnBeforeAddAnnotation();
}
