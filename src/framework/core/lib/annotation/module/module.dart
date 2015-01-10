/**
 * Collection of annotations for
 * creating modules.
 *
 * example implementation of a module:
 *
 *     library myLib.module;
 *
 *     @Module("1.3.37")
 *     class ExampleModule {
 *
 *         @NavigationParameter -> TODO
 *         NavigationParameter params;
 *
 *         @Inject("CustomModule") -> TODO
 *         FrameworkModule customModule;
 *
 *         @Navigator -> TODO
 *         Navigator navigator;
 *
 *         @TemplateProperty -> TODO
 *         Property<String> moduleTitle;
 *
 *         @TemplateCallback -> TODO
 *         void showInfo(TemplateCallbackEventArgs args) { ... }
 *
 *         @OnInit
 *         void initModule(ModuleContext context, InitEventArgs args) { ... }
 *
 *         @OnBeforeAdd
 *         void onBeforeAddEventHandler(NavigationEventArgs args) { ... }
 *
 *         @OnAdded
 *         void onAddedEventHandler(NavigationEventArgs args) { ... }
 *
 *         @OnBeforeRemove
 *         void onBeforeRemoveEventHandler() { ... }
 *
 *         @OnRemoved
 *         void onRemovedEventHandler() { ... }
 *
 *         @OnLoadingStateChanged(isLoading: true)
 *         void onLoadingStartedEventHandler(LoadingStateChangedEventArgs args) { ... }
 *
 *         @OnRequestCompleted(requestId: "news", isErrorHandler: true)
 *         void onNewsRequestErrorEventHandler(RequestCompletedEventArgs args) { ... }
 *     }
 *
 * example instantiation of the example module:
 *
 *     var exampleModule =
 *         new AnnotatedModule(
 *             "myLib.module",
 *             "ExampleModule",
 *             "fragment_id",{
 *                 "exampleConfigKey": true
 *             }
 *         );
 *
 */
library modularity.core.annotation.module;

part 'on_added.dart';
part 'on_before_add.dart';
part 'on_before_remove.dart';
part 'on_init.dart';
part 'on_loading_state_changed.dart';
part 'on_removed.dart';
part 'on_request_completed.dart';

//TODO document


class TemplateCallback {
  final String callbackName;
  
  const TemplateCallback({this.callbackName});
}

const Object TemplateProperty = const TemplatePropertyAnnotation();

class TemplatePropertyAnnotation {
  const TemplatePropertyAnnotation();
}

/**
 * Annotation which marks a class as module.
 * Each module requires a version number with
 * the following pattern: [{int}.{int}.{int}]
 * like ["1.0.0"].
 *
 * example usage:
 *
 *     @Module("1.0.0")
 *     class ExampleModule { ... }
 *
 *     @Module("1.0.0",
 *         author: "Author name",
 *         company: "Company name",
 *         eMail: "example@email.com",
 *         website: "http://www.example.com")
 *     class ExampleModuleWithOptionalAuthorInfo { ... }
 */
class Module {

  /**
   * Gets the author name of the module.
   */
  final String author;

  /**
   * Gets the company name of the author.
   */
  final String company;

  /**
   * Gets the e-mail of the author.
   */
  final String eMail;

  /**
   * Gets the website of the author.
   */
  final String website;

  /**
   * Gets the version number of the module.
   */
  final String version;

  /**
   * Initializes the [@Module] annotation.
   */
  const Module(this.version, {this.author, this.company, this.eMail, this.website});

}


