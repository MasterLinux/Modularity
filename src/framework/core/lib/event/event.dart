/**
 * Library to allow many to many relationships
 * between objects. So it is possible
 * to send messages from one object to
 * another with the help of custom signals.
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
 *
 *     //disconnect to stop listening
 *     Disconnect
 *         .signal("loaded")
 *         .from(exampleClass.onLoadedSlot);
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
