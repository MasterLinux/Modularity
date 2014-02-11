library lib.test;

import 'package:unittest/vm_config.dart';
import 'package:unittest/unittest.dart';
import '../lib/event/event.dart';

part 'event/event_test.dart';

/**
 * Executes all tests of the
 * library.
 */
void main() {
  var eventTest = new EventTest();
  eventTest.execute();
}

