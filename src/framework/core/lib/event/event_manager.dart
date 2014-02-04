part of lib.core.event;

class EventManager {
  final String _signal;
  static Map<String, EventManager> _cache;
  List<Slot> _slots;

  factory EventManager(String signal) {
    if(_cache == null) {
      _cache = {};
    }

    if(_cache.containsKey(signal)) {
      return _cache[signal];

    } else {
      final connect = new EventManager._internal(signal);
      _cache[signal] = connect;
      return connect;
    }
  }

  /**
   * Initializes the event manager
   */
  EventManager._internal(this._signal) {
    _slots = new List<Function>();
  }

  /**
   * Emits the signal to
   * invoke each registered
   * slot asynchronously
   */
  Future emit(EventArgs args) {
    var slots = new List<Slot>.from(_slots);

    return Future.forEach(slots, (Slot slot) {
      slot.run(args);
    });
  }

  /**
   * Adds a slot
   */
  void operator +(Slot slot) {
    _slots.add(slot);
  }

  /**
   * Removes a specific slot
   */
  void operator -(Slot slot) {
    _slots.remove(slot);

    //remove signal if no slots are added anymore
    if(_slots.isEmpty) {
      _cache.remove(_signal);
    }
  }

}

