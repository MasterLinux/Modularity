library modularity.tests;

import 'package:scheduled_test/scheduled_test.dart' as test;
import 'package:unittest/html_config.dart';
import 'package:modularity/view/view.dart';
import 'package:modularity/manifest.dart';
import 'package:modularity/core.dart';

//import 'package:modularity/template/template.dart';
//import 'package:modularity/exception/exception.dart';
//import 'package:modularity/model/model.dart';
//import 'package:modularity/logger.dart';
//import 'package:modularity/annotation/module/module.dart' as annotation;

//import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

//part 'logger_test.dart';
//part 'application_builder_test.dart';
//part 'application_test.dart';

class TestViewModel extends ViewModel {
  String _title;

  void onChange(TextInput sender, TextChangedEventArgs args) {
    print(args.text);
  }

  set title(String title) {
    _title = title;
    notifyPropertyChanged("title");
  }

  String get title => _title;
}

/**
 * Executes all tests of the
 * library.
 */
void main() {
  useHtmlConfiguration();

  new Core().tests();

  /*
  var tpl = JSON.decode(
  """
  {
    "template": {
      "type": "TextInput",
      "attributes": [{
        "name": "text",
        "binding": "title",
        "value": "initial value"
      }],
      "events": [{
        "name": "onTextChanged",
        "binding": "onChange"
      }],
      "subviews": []
    }
  }
  """);

  var model = new ViewTemplateConverter().convert(tpl["template"]);

  var vm = new TestViewModel();
  var ren = new ViewTemplate.fromModel(model, viewModel: vm);
  ren.render("#body");   */

  //vm.title = "test";
  //ren.destroy();

  /*

  var tplMap = JSON.decode('''{
       "type": "StackPanel",
       "attributes": [{
         "name": "orientation",
         "value": "horizontal"
       }],
       "children": [{
         "type": "Button",
         "attributes": [{
           "name": "title",
           "value": "Cancel"
         }],
         "children": []
       }, {
         "type": "Button",
         "events": [{
           "type": "click",
           "binding": {
              "callback": "showInfo",
              "parameter": []
           }
         }],
         "attributes": [{
           "name": "title",
           "value": "OK"
         }],
         "children": []
       }]
     }''');

  var menu = new Module(
      "modularity.tests", "MenuModule", tplMap, {
          "title": "That's an init text!"
      }
  );

  var tpl = new JsonTemplate(tplMap, "tplId", menu);
  print(tpl.node.children.length);

  tpl.render("body");

  //new LoggerTest().run();
  //new ApplicationBuilderTest().run();
  //new ApplicationTest().run();  */
}
              /*
@annotation.ApplicationModule("1.0.5")
class MenuModule {

  @annotation.TemplateCallback()
  void showInfo(args) {
    print("test click");
  }

  @annotation.TemplateProperty
  Property<String> title = new Property<String>.withValue("test");

  @annotation.OnInit
  void init(context, args) {

  }
}    */