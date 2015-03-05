part of modularity.tests;

class LoggerTest {
  final String NAMESPACE = "test_namespace";
  final String APP_NAME = "test_App_name";
  final String APP_VERSION = "1.0.0";
  final String PAGE_URI = "test_page";
  final String MESSAGE_CATEGORY = "test_category_1";
  final String ANOTHER_MESSAGE_CATEGORY = "test_category_2";

  void run() {
    test.test('logger should be initialized with defaults', () {
      var expectedLoggingMessageCount = 0;
      var expectedErrorCount = 2;
      var expectedAppNameErrorCount = 1;
      var expectedAppVersionErrorCount = 1;
      var loggerUnderTest = new Logger(isSynchronouslyModeEnabled: true);

      test.expect(loggerUnderTest, test.isNotNull);
      test.expect(loggerUnderTest.applicationName, Logger.defaultApplicationName);
      test.expect(loggerUnderTest.applicationVersion, Logger.defaultApplicationVersion);
      test.expect(loggerUnderTest.errorMessages, test.isNotNull);
      test.expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);
      test.expect(loggerUnderTest.warningMessages, test.isNotNull);
      test.expect(loggerUnderTest.warningMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.networkMessages, test.isNotNull);
      test.expect(loggerUnderTest.networkMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.lifecycleMessages, test.isNotNull);
      test.expect(loggerUnderTest.lifecycleMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.infoMessages, test.isNotNull);
      test.expect(loggerUnderTest.infoMessages.length, expectedLoggingMessageCount);

      //test empty parameter values
      loggerUnderTest = new Logger(applicationName: "", applicationVersion: "", isSynchronouslyModeEnabled: true);

      test.expect(loggerUnderTest, test.isNotNull);
      test.expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);

      //test null values
      loggerUnderTest = new Logger(applicationName: null, applicationVersion: null, isSynchronouslyModeEnabled: true);

      test.expect(loggerUnderTest, test.isNotNull);
      test.expect(loggerUnderTest.errorMessages.length, expectedErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationNameError).length, expectedAppNameErrorCount);
      test.expect(loggerUnderTest.errorMessages.where((message) => message is MissingApplicationVersionError).length, expectedAppVersionErrorCount);
    });

    test.test('logger should be initialized with app name and version', () {
      var expectedLoggingMessageCount = 0;
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);

      test.expect(loggerUnderTest, test.isNotNull);
      test.expect(loggerUnderTest.applicationName, APP_NAME);
      test.expect(loggerUnderTest.applicationVersion, APP_VERSION);
      test.expect(loggerUnderTest.errorMessages, test.isNotNull);
      test.expect(loggerUnderTest.errorMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.warningMessages, test.isNotNull);
      test.expect(loggerUnderTest.warningMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.networkMessages, test.isNotNull);
      test.expect(loggerUnderTest.networkMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.lifecycleMessages, test.isNotNull);
      test.expect(loggerUnderTest.lifecycleMessages.length, expectedLoggingMessageCount);
      test.expect(loggerUnderTest.infoMessages, test.isNotNull);
      test.expect(loggerUnderTest.infoMessages.length, expectedLoggingMessageCount);
    });

    test.test('logger should clear all logging messages', () {
      var expectedLoggingMessageCountBeforeClear = 2;
      var expectedLoggingMessageCountAfterClear = 0;
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);

      test.schedule(() {
        return Future.wait([
          loggerUnderTest.log(new MissingApplicationVersionError(NAMESPACE)),
          loggerUnderTest.log(new PageExistsWarning(NAMESPACE, PAGE_URI))
        ]).then((_) {
          test.expect(loggerUnderTest, test.isNotNull);
          test.expect(loggerUnderTest.messages, test.isNotNull);
          test.expect(loggerUnderTest.messages.length, expectedLoggingMessageCountBeforeClear);

          return test.schedule(() {
            return loggerUnderTest.clear().then((_) {
              test.expect(loggerUnderTest.messages, test.isNotNull);
              test.expect(loggerUnderTest.messages.length, expectedLoggingMessageCountAfterClear);

            });
          });
        });
      });
    });

    test.test('logger should notify observer on logging message received', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCount = 8;
      var expectedWarningMessageCount = 2;
      var expectedCustomMessageCount = 2;
      var expectedSpecificCustomMessageCount = 1;
      var expectedSpecificMessageCount = 1;
      var expectedNetworkMessageCount = 1;
      loggerUnderTest.register(observerUnderTest);

      test.schedule(() {
        return Future.wait([
            loggerUnderTest.log(new PageExistsWarning(NAMESPACE, PAGE_URI)),
            loggerUnderTest.log(new ErrorMessage(NAMESPACE)),
            loggerUnderTest.log(new WarningMessage(NAMESPACE)),
            loggerUnderTest.log(new InfoMessage(NAMESPACE)),
            loggerUnderTest.log(new LifecycleMessage(NAMESPACE)),
            loggerUnderTest.log(new NetworkMessage(NAMESPACE)),
            loggerUnderTest.log(new CustomMessage(NAMESPACE, MESSAGE_CATEGORY)),
            loggerUnderTest.log(new CustomMessage(NAMESPACE, ANOTHER_MESSAGE_CATEGORY))
        ]).then((_) {
          //test observer
          test.expect(observerUnderTest.messages, test.isNotNull);
          test.expect(observerUnderTest.messages.length, expectedMessageCount);
          test.expect(observerUnderTest.messages.where((message) => message is WarningMessage).length, expectedWarningMessageCount);
          test.expect(observerUnderTest.messages.where((message) => message is NetworkMessage).length, expectedNetworkMessageCount);
          test.expect(observerUnderTest.messages.where((message) => message is CustomMessage).length, expectedCustomMessageCount);

          //test logger
          test.expect(loggerUnderTest.messages.length, expectedMessageCount);
          test.expect(loggerUnderTest.errorMessages.length, expectedSpecificMessageCount);
          test.expect(loggerUnderTest.warningMessages.length, expectedWarningMessageCount);
          test.expect(loggerUnderTest.infoMessages.length, expectedSpecificMessageCount);
          test.expect(loggerUnderTest.lifecycleMessages.length, expectedSpecificMessageCount);
          test.expect(loggerUnderTest.networkMessages.length, expectedSpecificMessageCount);
          test.expect(loggerUnderTest.customMessages.length, expectedCustomMessageCount);
          test.expect(loggerUnderTest.getCustomMessagesOfCategory(MESSAGE_CATEGORY).length, expectedSpecificCustomMessageCount);
          test.expect(loggerUnderTest.getCustomMessagesOfCategory(ANOTHER_MESSAGE_CATEGORY).length, expectedSpecificCustomMessageCount);
        });
      });
    });

    test.test('logger should notify observer on messages cleared', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCountBeforeClear = 1;
      var expectedMessageCountAfterClear = 0;
      loggerUnderTest.register(observerUnderTest);

      test.schedule(() {
        return loggerUnderTest.log(new MissingApplicationVersionError(NAMESPACE)).then((_) {
          var actualMessages = observerUnderTest.messages.where((msg) => msg is MissingApplicationVersionError);
          test.expect(observerUnderTest.messages.length, expectedMessageCountBeforeClear);

          return test.schedule(() {
            return loggerUnderTest.clear().then((_) {
              test.expect(observerUnderTest.messages.length, expectedMessageCountAfterClear);

            });
          });
        });
      });
    });

    test.test('logger should unregister observer', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      loggerUnderTest.register(observerUnderTest);
      var expectedMessageCount = 1;

      //first message should be received
      test.schedule(() {
        return loggerUnderTest.log(new ErrorMessage(NAMESPACE)).then((_) {
          test.expect(observerUnderTest.messages, test.isNotNull);
          test.expect(observerUnderTest.messages.length, expectedMessageCount);

          loggerUnderTest.unregister(observerUnderTest);

          //the second message shouldn't appear
          return test.schedule(() {
            return loggerUnderTest.log(new ErrorMessage(NAMESPACE)).then((_) {
              test.expect(observerUnderTest.messages, test.isNotNull);
              test.expect(observerUnderTest.messages.length, expectedMessageCount);

              //and clear shouldn't affect, too
              return test.schedule(() {
                return loggerUnderTest.clear().then((_) {
                  test.expect(observerUnderTest.messages, test.isNotNull);
                  test.expect(observerUnderTest.messages.length, expectedMessageCount);

                });
              });
            });
          });
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
