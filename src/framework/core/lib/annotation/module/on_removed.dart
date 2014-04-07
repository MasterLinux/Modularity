part of lib.core.annotation.module;

/**
 * The [@OnRemoved] annotation is used to mark a function
 * as event handler for the onRemoved event of a module.
 *
 * example usage:
 *
 *     @OnRemoved
 *     void onRemovedEventHandler() { ... }
 *
 */
const Object OnRemoved = const OnRemovedAnnotation();

/**
 * This class is used by the [@OnRemoved] annotation and
 * must not used directly. See [OnRemoved] annotation
 * for more information.
 */
class OnRemovedAnnotation {
  const OnRemovedAnnotation();
}
