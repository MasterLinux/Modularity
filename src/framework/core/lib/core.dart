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