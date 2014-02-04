part of lib.core.event;

class Disconnect {
  EventManager manager;

  static Disconnect signal(String signal) {
    return new Disconnect._internal(signal);
  }

  Disconnect._internal(String signal) {
    manager = new EventManager(signal);
  }

  Disconnect from(Slot slot) {
    manager - slot;
    return this;
  }
}
