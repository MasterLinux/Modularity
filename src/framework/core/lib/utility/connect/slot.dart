part of lib.core.utility.connect;

/**
 * Represents an event handler or callback
 * which can be executed asynchronously.
 *
 * example usage:
 *
 *      //create a new slot instance
 *      var slot = new Slot((EventArgs args) {
 *          //do expensive work
 *      });
 *
 *      //invoke event handler
 *      slot.run(
 *          new EventArgs.from({
 *              ...
 *          })
 *      );
 */
class Slot {
  Function _handler;

  /**
   * Initializes the slot with the help
   * of the [handler] which should be
   * invoked when a specific signal is emitted.
   */
  Slot(void handler(SignalEventArgs args)) {
    _handler = handler;
  }

  /**
   * Invokes the event handler
   * asynchronously and hands over
   * the event arguments [EventArgs]
   * of the emitted signal.
   */
  Future run(SignalEventArgs args) {
    var completer = new Completer();

    //run handler
    new Future(() {
      _handler(args);
      completer.complete();
    });

    return completer.future;
  }
}
