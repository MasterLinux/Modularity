part of modularity.core.annotation.module;

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

/**
 * This class is used by the [@OnBeforeRemove] annotation and
 * must not used directly. See [OnBeforeRemove] annotation
 * for more information.
 */
class OnBeforeRemoveAnnotation {
  const OnBeforeRemoveAnnotation();
}
