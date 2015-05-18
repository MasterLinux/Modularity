part of modularity.core.annotation.module;

//TODO remove annotation

/**
 * Annotation which marks a function
 * as init function of a module. A module
 * must contain one init function.
 * In addition an init function is just
 * invoked once when the module is initialized
 * on application start.
 *
 * example usage:
 *
 *     @OnInit
 *     void init(ModuleContext context, InitEventArgs args) {
 *         //do something important
 *     }
 *
 */
@Deprecated("Use constructor instead")
const Object OnInit = const OnInitAnnotation();

/**
 * This class is used by the [@OnInit] annotation and
 * must not used directly. See [OnInit] annotation
 * for more information.
 */
class OnInitAnnotation {
  const OnInitAnnotation();
}
