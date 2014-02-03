library lib.core;

import 'dart:html';
import 'dart:async';

import 'event/event.dart';

part 'application.dart';
part 'page.dart';
part 'fragment.dart';
part 'module.dart';
part 'config.dart';

class LolEventArgs extends EventArgs {
  String get text {
    return "lol";
  }
}

class RoflEventArgs extends EventArgs {
  String get text {
    return "rofl";
  }
}

class Core {
  Core() {

  }

  void tests() {
    var module = new Module("rofl");
    new Connect("test")
      .to(module.printEvent)
      .to(module.printEvent)
      .emit(new LolEventArgs())
      .remove(module.printEvent)
      .emit(new RoflEventArgs());
  }
}

void main() {
  new Core().tests();
}