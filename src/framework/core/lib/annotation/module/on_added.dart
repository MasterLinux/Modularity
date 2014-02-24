part of lib.core.annotation.module;

/**
 * The [@OnAdded] annotation is used to mark a function
 * as event handler for the onAdded event of a module.
 *
 * example usage:
 *
 *     @OnAdded
 *     void onAddedEventHandler() { ... }
 *
 */
const Object OnAdded = const OnAddedAnnotation();

class OnAddedAnnotation {
  const OnAddedAnnotation();
}
