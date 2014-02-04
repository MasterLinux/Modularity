part of lib.core.event;

class Slot {
  Function _handler;

  Slot(void handler(EventArgs args)) {
    _handler = handler;
  }

  Future run(EventArgs args) {
    return new Future(() => _handler(args));
  }
}
