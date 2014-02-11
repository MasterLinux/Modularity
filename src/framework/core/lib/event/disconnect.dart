part of lib.core.event;

/**
 * Disconnects a specific signal from a slot.
 *
 * example usage:
 *
 *     //create new example class which contains a slot
 *     var exampleClass = new ExampleClass();
 *
 *     //connect the loaded signal to a slot
 *     Disconnect
 *         .signal("loaded")
 *         .from(exampleClass.onLoadedSlot);
 *
 */
class Disconnect {
  EventManager _manager;

  /**
   * Gets or creates a new instance
   * of this helper to disconnect a
   * specific [signal] from slot
   * connected by [Connect] helper.
   */
  static Disconnect signal(String signal) {
    return new Disconnect._internal(signal);
  }

  /**
   * Initializes the disconnect helper
   * with the help of a specific [signal].
   */
  Disconnect._internal(String signal) {
    _manager = new EventManager(signal);
  }

  /**
   * Disconnects a specific [slot] from
   * the signal of this helper.
   */
  Disconnect from(Slot slot) {
    _manager - slot;
    return this;
  }

  Disconnect all() {
    _manager.clear();
    return this;
  }
}
