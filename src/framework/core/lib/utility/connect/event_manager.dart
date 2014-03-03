part of lib.core.utility.connect;

/**
 * An event manager used to create many to many
 * relationships between objects. In addition it
 * allows the communication between these objects
 * using custom signals.
 *
 * This class must not be used. Use [Connect]
 * and [Disconnect] instead.
 *
 * example usage:
 *
 *      //create new example class which contains a slot
 *      var exampleClass = new ExampleClass();
 *
 *      //create new manager instance
 *      var manager = new _EventManager("loaded");
 *
 *      //subscribe slot
 *      manager + exampleClass.onLoadedSlot;
 *
 *      //emit signal
 *      manager.emit(
 *          new EventArgs.from({
 *              ...
 *          })
 *      );
 *
 *      //unsubscribe slot
 *      manager - exampleClass.onLoadedSlot;
 *
 */
class _EventManager {
  final String _signal;
  static Map<String, _EventManager> _cache;
  List<Slot> _slots;

  /**
   * Gets or creates a new instance
   * of this event manager listening
   * to a specific [signal].
   */
  factory _EventManager(String signal) {
    if(_cache == null) {
      _cache = {};
    }

    if(_cache.containsKey(signal)) {
      return _cache[signal];

    } else {
      final connect = new _EventManager._internal(signal);
      _cache[signal] = connect;
      return connect;
    }
  }

  /**
   * Initializes the event manager
   * listening to a specific [signal].
   */
  _EventManager._internal(this._signal) {
    _slots = <Slot>[];
  }

  /**
   * Gets the number of slots
   * subscribed to the signal
   * of this event manager.
   */
  int get count {
    return _slots.length;
  }

  /**
   * Emits the signal of this
   * event manager and invokes
   * each subscribed slot
   * asynchronously.
   * //TODO comment return Future
   */
  Future emit(SignalEventArgs args) {
    var slots = new List<Slot>.from(_slots);

    return Future.forEach(slots, (slot) {
      return slot.run(args);
    });
  }

  /**
   * Subscribes a [Slot] which will be
   * invoked whenever the signal
   * of this event manager is emitted.
   */
  void operator +(Slot slot) {
    _slots.add(slot);
  }

  /**
   * Unsubscribes a specific [Slot].
   */
  void operator -(Slot slot) {
    _slots.remove(slot);

    //remove signal if no slots are added anymore
    if(_slots.isEmpty) {
      _cache.remove(_signal);
    }
  }

  /**
   * Unsubscribes all slots from this
   * event manager.
   */
  void clear() {
    _slots.clear();
  }
}

