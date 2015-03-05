part of modularity.core.annotation.module;

/**
 * The [@OnBeforeAdd] annotation is used to mark a function
 * as event handler for the onBeforeAdd event of a module.
 *
 * example usage:
 *
 *     @OnBeforeAdd
 *     void onBeforeAddEventHandler(NavigationEventArgs args) { ... }
 *
 */
const Object OnBeforeAdd = const OnBeforeAddAnnotation();

/**
 * This class is used by the [@OnBeforeAdd] annotation and
 * must not used directly. See [OnBeforeAdd] annotation
 * for more information.
 */
class OnBeforeAddAnnotation {
  const OnBeforeAddAnnotation();
}
