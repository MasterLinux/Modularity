part of lib.core.event;

/**
 * Connects a specific signal to many
 * slots which will be invoked when
 * this signal is emitted.
 *
 * example usage:
 *
 *     //create new example class which contains a slot
 *     var exampleClass = new ExampleClass();
 *
 *     //connect the loaded signal to a slot
 *     Connect
 *         .signal("loaded")
 *         .to(exampleClass.onLoadedSlot);
 *
 *     //emit signal
 *     Connect
 *         .signal("loaded")
 *         .emit(
 *             new EventArgs.from({
 *                 ...
 *             })
 *         );
 */
class Connect {
  EventManager _manager;

  /**
   * Gets or creates a new instance
   * of this connect helper listening
   * to a specific [signal].
   */
  static Connect signal(String signal) {
    return new Connect._internal(signal);
  }

  /**
   * Initializes the connect helper
   * listening to a specific [signal].
   */
  Connect._internal(String signal) {
    _manager = new EventManager(signal);
  }

  /**
   * Connects a specific [Slot] to the
   * signal of this connect helper.
   */
  Connect to(Slot slot) {
    _manager + slot;
    return this;
  }

  /**
   * Invokes all slots connected to
   * the signal of this connect helper.
   * The [EventArgs] contains all required
   * event data.
   */
  Connect emit(EventArgs args) {
    _manager.emit(args);
    return this;
  }
}
