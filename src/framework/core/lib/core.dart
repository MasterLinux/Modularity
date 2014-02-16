library lib.core;

import 'dart:html';
import 'dart:async';

import 'utility/utility.dart';
import 'event/event.dart';

part 'application.dart';
part 'page.dart';
part 'fragment.dart';
part 'module.dart';
part 'config.dart';
part 'event_args.dart';
part 'navigation_event_args.dart';
part 'missing_navigation_parameter_exception.dart';

class Core {
  Core() {

  }

  void tests() {
    var module = new Module(
        "fragment_id", {
          "test": new Core()
        });
  }
}

void main() {
  new Core().tests();
}