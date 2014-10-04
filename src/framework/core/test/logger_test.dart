part of modularity.tests;

class LoggerTest {
  final String NAMESPACE = "test_namespace";
  final String APP_NAME = "test_App_name";
  final String APP_VERSION = "1.0.0";
  final String PAGE_URI = "test_page";
  final String MESSAGE_CATEGORY = "test_category_1";
  final String ANOTHER_MESSAGE_CATEGORY = "test_category_2";

  void run() {
    test('logger should be initialized with defaults', () {
      var expectedLoggingMessageCount = 0;
      var expectedErrorCount = 2;
      var expectedAppNameErrorCount = 1;
      var expectedAppVersionErrorCount = 1;
      var loggerUnderTest = new Logger(isSynchronouslyModeEnabled: true);

      expect(loggerUnderTest, isNotNull);
      expect(loggerUnderTest.applicationName, Logger.defaultApplicationName);
      expect(loggerUnderTest.applicationVersion, Logger.defaultApplicationVersion);
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

    test('logger should be initialized with app name and version', () {
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
          loggerUnderTest.log(new MissingApplicationVersionError(NAMESPACE)),
          loggerUnderTest.log(new PageExistsWarning(NAMESPACE, PAGE_URI))
        ]).then((_) {
          expect(loggerUnderTest, isNotNull);
          expect(loggerUnderTest.messages, isNotNull);
          expect(loggerUnderTest.messages.length, expectedLoggingMessageCountBeforeClear);

          return schedule(() {
            return loggerUnderTest.clear().then((_) {
              expect(loggerUnderTest.messages, isNotNull);
              expect(loggerUnderTest.messages.length, expectedLoggingMessageCountAfterClear);

            });
          });
        });
      });
    });

    test('logger should notify observer on logging message received', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCount = 8;
      var expectedWarningMessageCount = 2;
      var expectedCustomMessageCount = 2;
      var expectedSpecificCustomMessageCount = 1;
      var expectedSpecificMessageCount = 1;
      var expectedNetworkMessageCount = 1;
      loggerUnderTest.register(observerUnderTest);

      schedule(() {
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
          expect(observerUnderTest.messages, isNotNull);
          expect(observerUnderTest.messages.length, expectedMessageCount);
          expect(observerUnderTest.messages.where((message) => message is WarningMessage).length, expectedWarningMessageCount);
          expect(observerUnderTest.messages.where((message) => message is NetworkMessage).length, expectedNetworkMessageCount);
          expect(observerUnderTest.messages.where((message) => message is CustomMessage).length, expectedCustomMessageCount);

          //test logger
          expect(loggerUnderTest.messages.length, expectedMessageCount);
          expect(loggerUnderTest.errorMessages.length, expectedSpecificMessageCount);
          expect(loggerUnderTest.warningMessages.length, expectedWarningMessageCount);
          expect(loggerUnderTest.infoMessages.length, expectedSpecificMessageCount);
          expect(loggerUnderTest.lifecycleMessages.length, expectedSpecificMessageCount);
          expect(loggerUnderTest.networkMessages.length, expectedSpecificMessageCount);
          expect(loggerUnderTest.customMessages.length, expectedCustomMessageCount);
          expect(loggerUnderTest.getCustomMessagesOfCategory(MESSAGE_CATEGORY).length, expectedSpecificCustomMessageCount);
          expect(loggerUnderTest.getCustomMessagesOfCategory(ANOTHER_MESSAGE_CATEGORY).length, expectedSpecificCustomMessageCount);
        });
      });
    });

    test('logger should notify observer on messages cleared', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      var expectedMessageCountBeforeClear = 1;
      var expectedMessageCountAfterClear = 0;
      loggerUnderTest.register(observerUnderTest);

      schedule(() {
        return loggerUnderTest.log(new MissingApplicationVersionError(NAMESPACE)).then((_) {
          var actualMessages = observerUnderTest.messages.where((msg) => msg is MissingApplicationVersionError);
          expect(observerUnderTest.messages.length, expectedMessageCountBeforeClear);

          return schedule(() {
            return loggerUnderTest.clear().then((_) {
              expect(observerUnderTest.messages.length, expectedMessageCountAfterClear);

            });
          });
        });
      });
    });

    test('logger should unregister observer', () {
      var loggerUnderTest = new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION);
      var observerUnderTest = new ObserverMock();
      loggerUnderTest.register(observerUnderTest);
      var expectedMessageCount = 1;

      //first message should be received
      schedule(() {
        return loggerUnderTest.log(new ErrorMessage(NAMESPACE)).then((_) {
          expect(observerUnderTest.messages, isNotNull);
          expect(observerUnderTest.messages.length, expectedMessageCount);

          loggerUnderTest.unregister(observerUnderTest);

          //the second message shouldn't appear
          return schedule(() {
            return loggerUnderTest.log(new ErrorMessage(NAMESPACE)).then((_) {
              expect(observerUnderTest.messages, isNotNull);
              expect(observerUnderTest.messages.length, expectedMessageCount);

              //and clear shouldn't affect, too
              return schedule(() {
                return loggerUnderTest.clear().then((_) {
                  expect(observerUnderTest.messages, isNotNull);
                  expect(observerUnderTest.messages.length, expectedMessageCount);

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
