part of lib.core.utility.connect;

/**
 * Provides data of an event
 *
 * example usage:
 *
 *      //create a new instance
 *      var args = new EventArgs.from({
 *          "title": "example_title",
 *          "handler": (title) {
 *              print(title);
 *          }
 *      });
 *
 *      //check whether all required arguments are available
 *      var hasHandler = args.hasArgument("handler");
 *      var hasName = args.hasArgument("title");
 *
 *      //if so execute handler
 *      if(hasName && hasHandler) {
 *
 *          //get and cast arguments
 *          var handler = args["handler"] as Function;
 *          var title = args["title"] as String;
 *
 *          //do crazy stuff
 *          handler(title);
 *      }
 *
 */
class SignalEventArgs { //TODO extends EventArgs
  Map<String, dynamic> _args;

  /**
   * Initializes the event args with the
   * help of a map of [arguments].
   */
  SignalEventArgs.from(Map<String, dynamic> arguments) {
    _args = arguments;

    if(_args == null) {
      _args = <String, dynamic>{};
    }
  }

  /**
   * Gets an argument by its [name] or
   * returns null if this event arguments
   * doesn't contain an argument with
   * the given name.
   */
  Object operator [](String name) {
    return _args.containsKey(name) ? _args[name] : null;
  }

  /**
   * Returns true if this event arguments contains
   * an argument with the given [name].
   */
  bool hasArgument(String name) {
    return _args.containsKey(name);
  }
}
