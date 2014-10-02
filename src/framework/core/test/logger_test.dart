part of modularity.tests;

class LoggerTest {
  final String LOGGER_NAMESPACE = "test_namespace";
  final String APP_NAME = "test_App_name";
  final String APP_VERSION = "1.0.0";
  final String PAGE_URI = "test_page";

  void run() {
    test('logger should be initialized without app name and version', () {
      var expectedLoggingMessageCount = 0;
      var expectedErrorCount = 2;
      var expectedAppNameErrorCount = 1;
      var expectedAppVersionErrorCount = 1;
      var loggerUnderTest = new Logger(isSynchronouslyModeEnabled: true);

      expect(loggerUnderTest, isNotNull);
      expect(loggerUnderTest.applicationName, Logger.DEFAULT_APPLICATION_NAME);
      expect(loggerUnderTest.applicationVersion, Logger.DEFAULT_APPLICATION_VERSION);
      expect(loggerUnderTest.errorMessages, isNotNull);
      expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);
      expect(loggerUnderTest.warningMessages, isNotNull);
      expect(loggerUnderTest.warningMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.networkMessages, isNotNull);
      expect(loggerUnderTest.networkMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.lifecycleMessages, isNotNull);
      expect(loggerUnderTest.lifecycleMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.infoMessages, isNotNull);
      expect(loggerUnderTest.infoMessages.length, expectedLoggingMessageCount);

      //test empty parameter values
      loggerUnderTest = new Logger(applicationName: "", applicationVersion: "", isSynchronouslyModeEnabled: true);

      expect(loggerUnderTest, isNotNull);
      expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);

      //test null values
      loggerUnderTest = new Logger(applicationName: null, applicationVersion: null, isSynchronouslyModeEnabled: true);

      expect(loggerUnderTest, isNotNull);
      expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);
    });

    test('logger should be correctly initialized', () {
      var expectedLoggingMessageCount = 0;
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);

      expect(loggerUnderTest, isNotNull);
      expect(loggerUnderTest.applicationName, APP_NAME);
      expect(loggerUnderTest.applicationVersion, APP_VERSION);
      expect(loggerUnderTest.errorMessages, isNotNull);
      expect(loggerUnderTest.errorMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.warningMessages, isNotNull);
      expect(loggerUnderTest.warningMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.networkMessages, isNotNull);
      expect(loggerUnderTest.networkMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.lifecycleMessages, isNotNull);
      expect(loggerUnderTest.lifecycleMessages.length, expectedLoggingMessageCount);
      expect(loggerUnderTest.infoMessages, isNotNull);
      expect(loggerUnderTest.infoMessages.length, expectedLoggingMessageCount);
    });

    test('logger should clear all logging messages', () {
      var expectedLoggingMessageCountBeforeClear = 2;
      var expectedLoggingMessageCountAfterClear = 0;
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);

      schedule(() {
        return Future.wait([
          loggerUnderTest.logError(new MissingApplicationVersionError(LOGGER_NAMESPACE)),
          loggerUnderTest.logWarning(new PageExistsWarning(LOGGER_NAMESPACE, PAGE_URI))
        ]).then((_) {
          expect(loggerUnderTest, isNotNull);
          expect(loggerUnderTest.messages, isNotNull);
          expect(loggerUnderTest.messages.length, expectedLoggingMessageCountBeforeClear);

          loggerUnderTest.clear();

          expect(loggerUnderTest.messages, isNotNull);
          expect(loggerUnderTest.messages.length, expectedLoggingMessageCountAfterClear);
        });
      });
    });

    test('logger should notify observer on logging message received', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCount = 1;
      loggerUnderTest.register(observerUnderTest);

      schedule(() {
        return loggerUnderTest.logError(new MissingApplicationVersionError(LOGGER_NAMESPACE)).then((_) {
          var actualMessages = observerUnderTest.messages.where((msg) => msg is MissingApplicationVersionError);
          expect(actualMessages, isNotNull);
          expect(actualMessages.length, expectedMessageCount);
          expect(actualMessages.first is MissingApplicationVersionError, isTrue);
        });
      });
    });

    test('logger should notify observer on messages cleared', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCount = 1;
      loggerUnderTest.register(observerUnderTest);

      schedule(() {
        return loggerUnderTest.logError(new MissingApplicationVersionError(LOGGER_NAMESPACE)).then((_) {
          var actualMessages = observerUnderTest.messages.where((msg) => msg is MissingApplicationVersionError);
          expect(observerUnderTest.messages.length, expectedMessageCount);

          loggerUnderTest.clear();    //TODO make asnyc?

          expect(observerUnderTest.messages.length, 0);

        });
      });
    });
  }
}

class ObserverMock implements MessageObserver {
  List<LoggingMessage> messages = new List();

  void onMessageReceived(Logger sender, LoggingMessage message) {
    messages.add(message);
  }

  void onMessagesCleared(Logger sender) {
    messages.clear();
  }
}
