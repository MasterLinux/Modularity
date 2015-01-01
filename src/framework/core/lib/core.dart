library modularity.core;import 'dart:collection' show HashMap;import 'dart:async' show Future, Completer;import 'dart:mirrors'; //TODO import just the required stuffimport 'package:connect/connect.dart';import 'package:route_hierarchical/client.dart';import 'utility/utility.dart';import 'utility/class_utility.dart' as classUtil;import 'utility/string_utility.dart' as stringUtil;import 'model/model.dart';import 'event_args/event_args.dart';import 'exception/exception.dart';import 'annotation/module/module.dart' as annotations;import 'template/template.dart';import 'logger.dart';part 'application_builder.dart';part 'annotated_module.dart';part 'task.dart';part 'application.dart';part 'application_context.dart';part 'resource.dart';part 'page.dart';part 'fragment.dart';part 'module_context.dart';part 'config_loader.dart';part 'rest_api_config_loader.dart';part 'navigator.dart';//part 'config.dart';class Core {  Core() {  }  void tests() {    var tpl = new HtmlTemplate(      '''      <?xml version="1.0"?>      <vertical weight="20">        <header/> <!-- represents a fragment called header -->        <horizontal>          <navigation/>          <content/>        </horizontal>      </vertical>      '''    );    var html = tpl.template.toString();    var module = new Module(        "modularity.core", "TestModule", {          "test": null        });    module.add(false);    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null, isErrorOccurred: true));    module.onRequestCompleted(new RequestCompletedEventArgs("news", 200, null));    module.onRequestCompleted(new RequestCompletedEventArgs("lol", 200, null, isErrorOccurred: true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(true));    module.onLoadingStateChanged(new LoadingStateChangedEventArgs(false));    module.remove();    var menu = new Module(      "modularity.core", "MenuModule", {          "initText": "That's an init text!"      }    );  }}@annotations.Module("1.0.5")class MenuModule {  //Property<String> title = new Property<String>.withValue("test");  @annotations.OnInit  void init(ModuleContext context, InitEventArgs args) {    /*    var input = html.document.querySelector("#testInput");    title.bind(input);    title.listen((sender) {       print(sender.value);    });    title.value = "rofl";    title.unbind();    title.value = "rofl2";*/    new Future(() {      var i = 6;      //for(var i=0; i<5; i++) {        context.send(TestModule.SIGNAL_TEST, new SignalEventArgs.fromMap({            "message": "That's a test! - $i - ${args.config['initText']}",            "scale": i        }));      //}    });    new Future(() {      var i = 6;      //for(var i=0; i<5; i++) {        context.send(TestModule.SIGNAL_TEST, new SignalEventArgs.fromMap({            "message": "That's a second test! - $i - ${args.config['initText']}",            "scale": i        })).then((_) => print("completed"));      //}    });  }}@annotations.Module("1.0.0")class TestModule {  static const String SIGNAL_TEST = "TestModule_Test";  Slot get onTest => new Slot((args) {    print('${args["message"]} - onTest');  });  Slot get onExpensiveTest => new Slot((args) {    var scale = args["scale"] as int;    var n = 0;    for(var i=0; i<1000 * scale; i++) {      n+=i;    }    print('${args["message"]} - onExpensiveTest - $n - $scale');  });  @annotations.OnInit  void init(ModuleContext context, InitEventArgs args) {    print("init module: ${context.name} - ${context.version}");    //listen for signals    context.listen(SIGNAL_TEST, onExpensiveTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);    context.listen(SIGNAL_TEST, onTest);  }  @annotations.OnBeforeAdd  void beforeAdd() {    print("before add");  }  @annotations.OnAdded  void added() {    print("added");  }  @annotations.OnBeforeRemove  void beforeRemove() {    print("before remove");  }  @annotations.OnRemoved  void removed() {    print("removed");  }  @annotations.OnRequestCompleted()  void requestCompletedDefault(RequestCompletedEventArgs response) {    print("Request ${response.requestId} completed with error: ${response.isErrorOccurred}");  }  @annotations.OnRequestCompleted(requestId: "lol", isErrorHandler: true)  void requestLolCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @annotations.OnRequestCompleted(requestId: "news", isErrorHandler: true)  void requestNewsCompletedError(response) {    print("Request ${response.requestId} completed with error");  }  @annotations.OnRequestCompleted(requestId: "news")  void requestNewsCompleted(response) {    print("Request ${response.requestId} completed without error");  }  @annotations.OnLoadingStateChanged(isLoading: true)  void loadingStateChanged(response) {    print("App is loading: ${response.isLoading}");  }  @annotations.OnLoadingStateChanged()  void loadingStateChangedDefault(response) {    print("App is loading (default): ${response.isLoading}");  }}void main() {  new Core().tests();}