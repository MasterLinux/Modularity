library modularity.core.eventArgs;

import 'dart:collection'; //TODO just import HashMap

part 'init_event_args.dart';
part 'loading_state_changed_event_args.dart';
part 'navigation_event_args.dart';
part 'request_completed_event_args.dart';

/**
 * Marker interface for representing
 * a model which provides event data.
 */
abstract class EventArgs { }
