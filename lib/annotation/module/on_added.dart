part of modularity.core.annotation.module;

/**
 * The [@OnAdded] annotation is used to mark a function
 * as event handler for the onAdded event of a module.
 *
 * example usage:
 *
 *     @OnAdded
 *     void onAddedEventHandler(NavigationEventArgs args) { ... }
 *
 */
const Object OnAdded = const OnAddedAnnotation();

/**
 * This class is used by the [@OnAdded] annotation and
 * must not used directly. See [OnAdded] annotation
 * for more information.
 */
class OnAddedAnnotation {
  const OnAddedAnnotation();
}
