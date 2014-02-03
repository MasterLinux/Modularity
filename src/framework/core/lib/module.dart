part of lib.core;

class Module {
  String id;

  Module(this.id) {
  }

  void printEvent(EventArgs args) {
    var s = args["löl"];
    print((args["text"] as String) + " " + id);
  }
}
