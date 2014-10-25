library modularity.tests;

import 'package:scheduled_test/scheduled_test.dart' as test;
import 'package:unittest/html_config.dart';

import '../lib/exception/exception.dart';
import '../lib/model/model.dart';
import '../lib/core.dart';
import '../lib/logger.dart';
import '../lib/template/template.dart';
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

  var tpl = new PageTemplate(
      '''
      <?xml version="1.0"?>
      <vertical height="20">
        <header/> <!-- represents a fragment called header -->
        <horizontal>
          <navigation weight="10"/>
          <content/>
        </horizontal>
      </vertical>
      '''
  );

  print(tpl.toHtml().outerHtml);

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

