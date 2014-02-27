library lib.core;import 'dart:async';import 'dart:mirrors';import 'utility/utility.dart';import 'event/event.dart';import 'model/model.dart';import 'event_args/event_args.dart';import 'exception/exception.dart';import 'annotation/module/module.dart';part 'application.dart';part 'page.dart';part 'fragment.dart';part 'abstract_module.dart';part 'annotated_module.dart';part 'module_context.dart';part 'config.dart';class Core {  Core() {  }  void tests() {    var module = new AnnotatedModule(        "lib.core", "TestModule",        null, {          "test": null        });    module.add();    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null, isErrorOccurred: true));    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null));    module.onRequestCompleted(new RequestCompletedEventArgs("lol", 200, null, isErrorOccurred: true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(false));    module.remove();  }}@Module("1.0.0")class TestModule {  @OnInit  void init(ModuleContext context, InitEventArgs args) {    print("init module: ${context.name} - ${context.version}");  }  @OnBeforeAdd  void beforeAdd() {    print("before add");  }  @OnAdded  void added() {    print("added");  }  @OnBeforeRemove  void beforeRemove() {    print("before remove");  }  @OnRemoved  void removed() {    print("removed");  }  @OnRequestCompleted()  void requestCompletedDefault(RequestCompletedEventArgs response) {    print("Request ${response.requestId} completed with error: ${response.isErrorOccurred}");  }  @OnRequestCompleted(requestId: "lol", isErrorHandler: true)  void requestLolCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @OnRequestCompleted(requestId: "news", isErrorHandler: true)  void requestNewsCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @OnRequestCompleted(requestId: "news")  void requestNewsCompleted(response) {    print("Request ${response.requestId} completed without error");  }  @OnLoadingStateChanged(isLoading: true)  void loadingStateChanged(response) {    print("App is loading: ${response.isLoading}");  }  @OnLoadingStateChanged()  void loadingStateChangedDefault(response) {    print("App is loading (default): ${response.isLoading}");  }}void main() {  new Core().tests();}