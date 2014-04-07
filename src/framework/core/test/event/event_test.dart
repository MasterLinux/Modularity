part of lib.test;

class EventTest {
  Slot _onLoadedSlot;
  static const String _SIGNAL_LOADED = "loaded";

  EventTest() {
    _onLoadedSlot = new Slot((args) {
      print("is loaded");
    });
  }

  void execute() {

    _startConnectTest();
  }

  void _startConnectTest() {
    group('Connect', () {
      test('adding and removing slots', () {
        Connect
          .signal(_SIGNAL_LOADED)
          .to(_onLoadedSlot);

        expect(new EventManager(_SIGNAL_LOADED).count, equals(1));

        Connect
          .signal(_SIGNAL_LOADED)
          .to(_onLoadedSlot)
          .to(_onLoadedSlot)
          .to(_onLoadedSlot);

        expect(new EventManager(_SIGNAL_LOADED).count, equals(4));

        Disconnect
          .signal(_SIGNAL_LOADED)
          .from(_onLoadedSlot);

        expect(new EventManager(_SIGNAL_LOADED).count, equals(3));

        Disconnect
          .signal(_SIGNAL_LOADED)
          .from(_onLoadedSlot)
          .from(_onLoadedSlot);

        expect(new EventManager(_SIGNAL_LOADED).count, equals(1));

        Connect
          .signal(_SIGNAL_LOADED)
          .to(_onLoadedSlot);

        Disconnect
          .signal(_SIGNAL_LOADED)
          .all();

        expect(new EventManager(_SIGNAL_LOADED).count, equals(0));
      });
    });
  }
}
