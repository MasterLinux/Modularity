part of modularity.tests;

class ApplicationTest {
  final String DEFAULT_LANGUAGE = "de_DE";
  final String APP_NAME = "test_app_name";
  final String APP_VERSION = "1.1.1";
  final String PAGE_URI = "test_uri";
  final String PAGE_URI_SECOND = "test_uri_2";
  final String PAGE_URI_THIRD = "test_uri_3";

  void run() {
    test.test('application should use defaults if application info is not valid', () {
      var appUnderTest = new Application(new ApplicationInfo(), new Navigator());

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.name, Application.defaultName);
      test.expect(appUnderTest.startUri, test.isNull);
      test.expect(appUnderTest.language, Application.defaultLanguage);
      test.expect(appUnderTest.version, Application.defaultVersion);
      test.expect(appUnderTest.resources, test.isEmpty);
      test.expect(appUnderTest.pages, test.isEmpty);
      test.expect(appUnderTest.tasks, test.isEmpty);
      test.expect(appUnderTest.logger, test.isNull);
      test.expect(appUnderTest.navigator, test.isNotNull);
    });

    test.test('application should log logger messages on missing information', () {
      var appUnderTest = new Application(new ApplicationInfo(), new Navigator(), logger: new Logger(applicationName: "test_app", applicationVersion: "1.0.0", isSynchronouslyModeEnabled: true));

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.logger, test.isNotNull);
      test.expect(appUnderTest.logger.messages, test.isNotNull);
      test.expect(appUnderTest.logger.messages.where((msg) => msg is MissingApplicationNameError).isNotEmpty, test.isTrue, reason: "MissingApplicationNameError is missing");
      test.expect(appUnderTest.logger.messages.where((msg) => msg is MissingApplicationVersionError).isNotEmpty, test.isTrue, reason: "MissingApplicationVersionError is missing");
      test.expect(appUnderTest.logger.messages.where((msg) => msg is MissingDefaultLanguageWarning).isNotEmpty, test.isTrue, reason: "MissingDefaultLanguageWarning is missing");
    });

    test.test('application should be initialized', () {
      var appInfo = new ApplicationInfo()
          ..name = APP_NAME
          ..version = APP_VERSION
          ..language = DEFAULT_LANGUAGE;

      var appUnderTest = new Application(appInfo, new Navigator());

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.name, APP_NAME);
      test.expect(appUnderTest.startUri, test.isNull);
      test.expect(appUnderTest.language, DEFAULT_LANGUAGE);
      test.expect(appUnderTest.version, APP_VERSION);
      test.expect(appUnderTest.resources, test.isEmpty);
      test.expect(appUnderTest.pages, test.isEmpty);
      test.expect(appUnderTest.tasks, test.isEmpty);
      test.expect(appUnderTest.logger, test.isNull);
      test.expect(appUnderTest.navigator, test.isNotNull);
    });

    test.test('application should contain pages', () {
      var expectedPageCount = 3;

      var expectedFirstPage = new Page(PAGE_URI, null),
          expectedSecondPage = new Page(PAGE_URI_SECOND, null),
          expectedThirdPage = new Page(PAGE_URI_THIRD, null);

      var appUnderTest = new Application(new ApplicationInfo(), new Navigator())
        ..addPage(expectedFirstPage)
        ..addPages(<Page>[expectedSecondPage, expectedThirdPage]);

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.pages, test.isNotNull);
      test.expect(appUnderTest.pages.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.pages.length, expectedPageCount);
      test.expect(appUnderTest.pages.containsKey(expectedFirstPage.uri), test.isTrue);
      test.expect(appUnderTest.pages.containsKey(expectedSecondPage.uri), test.isTrue);
      test.expect(appUnderTest.pages.containsKey(expectedThirdPage.uri), test.isTrue);
      test.expect(appUnderTest.startUri, PAGE_URI);
    });

    test.test('application should contain tasks', () {
      var expectedTaskCount = 3;

      var expectedFirstTask = new Task("test_tast_1"),
          expectedSecondTask = new Task("test_task_2"),
          expectedThirdTask = new Task("test_task_3");

      var appUnderTest = new Application(new ApplicationInfo(), new Navigator())
        ..addTask(expectedFirstTask)
        ..addTasks(<Task>[expectedSecondTask, expectedThirdTask]);

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.tasks, test.isNotNull);
      test.expect(appUnderTest.tasks.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.tasks.length, expectedTaskCount);
      test.expect(appUnderTest.tasks.containsKey(expectedFirstTask.name), test.isTrue);
      test.expect(appUnderTest.tasks.containsKey(expectedSecondTask.name), test.isTrue);
      test.expect(appUnderTest.tasks.containsKey(expectedThirdTask.name), test.isTrue);
    });

    test.test('application should contain resources', () {
      var expectedResCount = 3;

      var expectedFirstRes = new Resource("de_DE", "Deutsch"),
      expectedSecondRes = new Resource("en_EN", "Englisch"),
      expectedThirdRes = new Resource("en_US", "Amerikanisch");

      var appUnderTest = new Application(new ApplicationInfo(), new Navigator())
        ..addResource(expectedFirstRes)
        ..addResources(<Resource>[expectedSecondRes, expectedThirdRes]);

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.resources, test.isNotNull);
      test.expect(appUnderTest.resources.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.resources.length, expectedResCount);
      test.expect(appUnderTest.resources.containsKey(expectedFirstRes.name), test.isTrue);
      test.expect(appUnderTest.resources.containsKey(expectedSecondRes.name), test.isTrue);
      test.expect(appUnderTest.resources.containsKey(expectedThirdRes.name), test.isTrue);
    });

    //start, stop, isStarted, info, navigator
  }

}