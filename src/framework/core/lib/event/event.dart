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
library lib.core.event;

import 'dart:mirrors';
import 'dart:async';
import 'dart:isolate';

part 'slot.dart';
part 'connect.dart';
part 'disconnect.dart';
part 'event_args.dart';
part 'event_manager.dart';
