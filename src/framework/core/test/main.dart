library modularity.tests;

import 'package:scheduled_test/scheduled_test.dart' as test;
import 'package:unittest/html_config.dart';

import '../lib/exception/exception.dart';
import '../lib/model/model.dart';
import '../lib/core.dart';
import 'mock/mock.dart';

import 'dart:async';
import 'dart:html' as html;

part 'logger_test.dart';
part 'application_builder_test.dart';
part 'application_test.dart';

/**
 * Executes all tests of the
 * library.
 */
void main() {
  useHtmlConfiguration();

  new LoggerTest().run();
  new ApplicationBuilderTest().run();
  new ApplicationTest().run();
}

//TODO fix matcher
/// A matcher for ApplicationLoadingExceptions.
//const Matcher isApplicationLoadingException = const _ApplicationLoadingException();

/*
class _ApplicationLoadingException extends TypeMatcher {
  const _ApplicationLoadingException(): super("ApplicationLoadingException");
  bool matches(item, Map matchState) => item is ApplicationLoadingException;
}*/

