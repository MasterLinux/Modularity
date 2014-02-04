library lib.core;

import 'dart:html';
import 'dart:async';

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
    var module = new Module("module_id");

    Connect.signal("test")
      .to(module.printEventExpensive)
      .to(module.printEvent)
      .to(module.printEvent)
      .emit(new EventArgs.from({
        "title": "example_title",
        "handler": (title) {
          print(title);
        }
      }))
      .emit(new EventArgs.from({
        "text": "rofl"
      }));

    /*
    Disconnect.signal("test")
      .from(module.printEvent);

    Connect.signal("test")
      .emit(new RoflEventArgs()); */
  }
}

void main() {
  new Core().tests();
}