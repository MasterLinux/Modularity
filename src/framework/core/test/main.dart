library modularity.tests;

//import 'package:unittest/vm_config.dart';
//import 'package:unittest/unittest.dart';
import 'package:scheduled_test/scheduled_test.dart';

import '../lib/core.dart';
import 'mock/mock.dart';

part 'application_test.dart';

/**
 * Executes all tests of the
 * library.
 */
void main() {
  new ApplicationTest().run();
}

