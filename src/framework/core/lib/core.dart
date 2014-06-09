library lib.core;import 'dart:async';import 'dart:mirrors';import 'package:connect/connect.dart';import 'utility/utility.dart';import 'utility/class_utility.dart' as classUtil;import 'model/model.dart';import 'event_args/event_args.dart';import 'exception/exception.dart';import 'annotation/module/module.dart';part 'application.dart';part 'page.dart';part 'fragment.dart';part 'annotated_module.dart';part 'module_context.dart';//part 'config.dart';class Core {  Core() {  }  void tests() {    var module = new AnnotatedModule(        "lib.core", "TestModule",        null, {          "test": null        });    module.add();    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null, isErrorOccurred: true));    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null));    module.onRequestCompleted(new RequestCompletedEventArgs("lol", 200, null, isErrorOccurred: true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(false));    module.remove();    var menu = new AnnotatedModule(      "lib.core", "MenuModule",      null, {          "initText": "That's an init text!"      }    );  }}@Module("1.0.5")class MenuModule {  @OnInit  void init(ModuleContext context, InitEventArgs args) {    new Future(() {      var i = 6;      //for(var i=0; i<5; i++) {        context.send(TestModule.SIGNAL_TEST, new SignalEventArgs.fromMap({            "message": "That's a test! - $i - ${args.config['initText']}",            "scale": i        }));      //}    });    new Future(() {      var i = 6;      //for(var i=0; i<5; i++) {        context.send(TestModule.SIGNAL_TEST, new SignalEventArgs.fromMap({            "message": "That's a second test! - $i - ${args.config['initText']}",            "scale": i        })).then((_) => print("completed"));      //}    });  }}@Module("1.0.0")class TestModule {  static const String SIGNAL_TEST = "TestModule_Test";  Slot get onTest => new Slot((args) {    print('${args["message"]} - onTest');  });  Slot get onExpensiveTest => new Slot((args) {    var scale = args["scale"] as int;    var n = 0;    for(var i=0; i<1000 * scale; i++) {      n+=i;    }    print('${args["message"]} - onExpensiveTest - $n - $scale');  });  @OnInit  void init(ModuleContext context, InitEventArgs args) {    print("init module: ${context.name} - ${context.version}");    //listen for signals    context.listen(SIGNAL_TEST, onExpensiveTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);  }  @OnBeforeAdd  void beforeAdd() {    print("before add");  }  @OnAdded  void added() {    print("added");  }  @OnBeforeRemove  void beforeRemove() {    print("before remove");  }  @OnRemoved  void removed() {    print("removed");  }  @OnRequestCompleted()  void requestCompletedDefault(RequestCompletedEventArgs response) {    print("Request ${response.requestId} completed with error: ${response.isErrorOccurred}");  }  @OnRequestCompleted(requestId: "lol", isErrorHandler: true)  void requestLolCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @OnRequestCompleted(requestId: "news", isErrorHandler: true)  void requestNewsCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @OnRequestCompleted(requestId: "news")  void requestNewsCompleted(response) {    print("Request ${response.requestId} completed without error");  }  @OnLoadingStateChanged(isLoading: true)  void loadingStateChanged(response) {    print("App is loading: ${response.isLoading}");  }  @OnLoadingStateChanged()  void loadingStateChangedDefault(response) {    print("App is loading (default): ${response.isLoading}");  }}void main() {  new Core().tests();}