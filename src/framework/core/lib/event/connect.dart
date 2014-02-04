part of lib.core.event;

class Connect {
  EventManager manager;

  static Connect signal(String signal) {
    return new Connect._internal(signal);
  }

  Connect._internal(String signal) {
    manager = new EventManager(signal);
  }

  Connect to(Slot slot) {
    manager + slot;
    return this;
  }

  Connect emit(EventArgs args) {
    manager.emit(args).whenComplete(print("ready"));
    return this;
  }
}
