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
 *         @OnInit
 *         void initModule(ModuleContext context, InitEventArgs args) { ... }
 *
 *         @OnBeforeAdd
 *         void onBeforeAddEventHandler() { ... }
 *
 *         @OnAdded
 *         void onAddedEventHandler() { ... }
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
library lib.core.annotation.module;

part 'on_added.dart';
part 'on_before_add.dart';
part 'on_before_remove.dart';
part 'on_init.dart';
part 'on_loading_state_changed.dart';
part 'on_removed.dart';
part 'on_request_completed.dart';

/**
 * Annotation which marks a class as module.
 * Each module requires a version number with
 * the following pattern: "{int}.{int}.[int}"
 * like "1.0.0".
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
  final String author;
  final String company;
  final String eMail;
  final String website;
  final String version;

  const Module(this.version, {this.author, this.company, this.eMail, this.website});
}
