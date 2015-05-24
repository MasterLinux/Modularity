library modularity.core;import 'dart:collection' show HashMap;import 'dart:async' show Future, Completer;import 'package:route_hierarchical/client.dart';import 'package:class_loader/class_loader.dart';import 'manifest.dart';import 'utility/utility.dart' as utility;import 'data/data.dart';import 'view/view.dart';part 'request.dart';part 'module.dart';part 'task.dart';part 'application.dart';part 'application_info.dart';part 'resource.dart';part 'page.dart';part 'fragment.dart';part 'navigator.dart';class Core {  Core() {  }  Future tests() async {    var manifest = new Manifest.fromJson('''{      "startUri": "home",      "language": "de-DE",      "version": "1.0.0",      "author": "Christoph",      "name": "Example App",      "pages": [{        "title": "Startseite",        "uri": "home",        "template": null,        "fragments": [{          "parentId": null,          "modules": [{            "lib": "modularity.core",            "name": "MenuModule",            "attributes": {              "title": "title_1"            }          },{            "lib": "modularity.core",            "name": "MenuModule",            "attributes": {              "title": "title_2"            }          },{            "lib": "modularity.core",            "name": "MenuModule"          }]        }]      }]    }''');    var app = new Application();    await app.applyManifest(manifest);    await app.run();  }}class MenuModule extends Module {  String _title;  View _view;  MenuModule(Fragment parent, Map<String, dynamic> attributes) : super(parent, attributes);  void set title(String title) {    _title = title;    notifyPropertyChanged("title");  }  String get title => _title;  @override  void onAdded(NavigationEventArgs args) {    print("onAdded");  }  @override  void onBeforeAdd(NavigationEventArgs args) {    print("onBeforeAdd");  }  @override  void onBeforeRemove() {    print("onBeforeRemove");  }  @override  void onInit() {    var s = hasAttribute("title") ? attributes["title"] : "no title";    print("onInit: ${s}");  }  @override  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {    print("onLoadingStateChanged");  }  @override  void onRemoved() {    print("onRemoved");  }  @override  void onRequestCompleted(RequestCompletedEventArgs args) {    print("onRequestCompleted");  }  // TODO: implement view  @override  View get view {    if(_view != null) {      _view = new TextInput();    }    return _view;  }}Future main() async {  await new Core().tests();}