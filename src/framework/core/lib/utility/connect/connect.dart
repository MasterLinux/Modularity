/**
 * Library to allow many to many relationships
 * between objects. So it is possible
 * to send messages from one object to
 * another with the help of custom signals.
 *
 * best practices:
 * TODO add description
 *
 * example usage:
 *
 *     class JsonReader {
 *         //a signal is a static constant with the class name as
 *         //prefix followed by the specific signal name and
 *         //separated by an underscore. For example "ClassName_SignalName"
 *         static const String SIGNAL_ON_COMPLETED = "JsonReader_onCompleted";
 *
 *         //reads a json from file and emits the onCompleted signal
 *         String readFrom(String path) {
 *             //emit onCompleted signal
 *             Connect
 *                 .signal(SIGNAL_ON_COMPLETED)
 *                 .emit(new EventArgs.from({
 *                     "isCompleted": false
 *                 }));
 *
 *             //read JSON file
 *             var json = file.read(path);
 *
 *             //emit onCompleted signal
 *             Connect
 *                 .signal(SIGNAL_ON_COMPLETED)
 *                 .emit(new EventArgs.from({
 *                     "isCompleted": true
 *                 }));
 *
 *             return json;
 *         }
 *     }
 *
 *     class LoadingIndicator {
 *         Slot _onLoadedCompletedSlot;
 *
 *         LoadingIndicator() {
 *
 *             //create new slot which hides or shows this
 *             //loading indicator on emitting signal
 *             _onLoadedCompletedSlot = new Slot((eventArgs) {
 *
 *                 //check whether required argument exist
 *                 var hasIsCompleted = args.hasArgument("isCompleted");
 *
 *                 if(hasIsCompleted) {
 *                     //get and cast argument
 *                     var isCompleted = args["isCompleted"] as bool;
 *
 *                     if(isCompleted) {
 *                         //hide loading indicator
 *                     } else {
 *                         //show loading indicator
 *                     }
 *                 }
 *             });
 *         }
 *
 *         void create() {
 *             Connect
 *                 .signal(JsonReader.SIGNAL_ON_COMPLETED)
 *                 .to(_onLoadedCompletedSlot);
 *         }
 *
 *         void destroy() {
 *             Disconnect
 *                 .signal(JsonReader.SIGNAL_ON_COMPLETED)
 *                 .from(_onLoadedCompletedSlot);
 *         }
 *
 *     }
 *
 *     //run example
 *     void main() {
 *         var loadingIndicator = new LoadingIndicator();
 *         var jsonReader = new JsonReader();
 *
 *         //initialize loading indicator
 *         loadingIndicator.create();
 *
 *         //get JSON
 *         jsonReader.readFrom("/path/to/file.json");
 *
 *         //desctruct loading indicator
 *         loadingIndicator.destroy();
 *     }
 *
 */
library lib.core.utility.connect;

import 'dart:mirrors';
import 'dart:async';
import 'dart:isolate';

part 'slot.dart';
part 'disconnect.dart';
part 'signal_event_args.dart';
part 'event_manager.dart';

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
  _EventManager _manager;

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
    _manager = new _EventManager(signal);
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
   * //TODO comment return Future
   */
  Future emit(SignalEventArgs args) {
    return _manager.emit(args);
  }
}
