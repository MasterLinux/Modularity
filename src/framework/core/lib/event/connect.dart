part of lib.core.event;

class Connect {
  final String signal;
  static Map<String, Connect> _cache;
  List<Slot> _slots;

  factory Connect(String signal) {
    if(_cache == null) {
      _cache = {};
    }

    if(_cache.containsKey(signal)) {
      return _cache[signal];

    } else {
      final connect = new Connect._internal(signal);
      _cache[signal] = connect;
      return connect;
    }
  }

  Connect._internal(this.signal) {
    _slots = new List<Function>();
  }

  Connect to(Slot slot) {
    _slots.add(slot);
    return this;
  }

  Connect remove(Slot slot) {
    _slots.remove(slot);

    //remove signal if no slots are added anymore
    if(_slots.isEmpty) {
      _cache.remove(signal);
    }

    return this;
  }

  Connect emit(EventArgs eventArgs) {

    for(var slot in _slots) {
      slot(eventArgs);
    }

    return this;
  }
}
