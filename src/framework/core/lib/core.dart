library lib.core;

//import 'dart:html';
import 'dart:async';
import 'dart:mirrors';

import 'utility/utility.dart';
import 'event/event.dart';

part 'application.dart';
part 'page.dart';
part 'fragment.dart';
part 'module.dart';
part 'annotated_module.dart';
part 'module_annotations.dart';
part 'config.dart';
part 'event_args.dart';
part 'init_event_args.dart';
part 'navigation_event_args.dart';
part 'missing_navigation_parameter_exception.dart';

class Core {
  Core() {

  }

  void tests() {
    var module = new AnnotatedModule.from(
        TestModule,
        "fragment_id", {
          "test": new Core()
        });

    module.add(false, null);
  }
}

@module("lib2", "testModule2")
class TestModule {

  @onInit
  void init(InitEventArgs args) {
    print("rofl");
  }


}

void main() {
  new Core().tests();
}