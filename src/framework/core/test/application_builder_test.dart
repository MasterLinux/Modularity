part of modularity.tests;

class ApplicationBuilderTest {
  final String APP_NAME = "test_App_name";
  final String APP_VERSION = "1.0.0";
  final String APP_AUTHOR = "test_author";
  final String START_PAGE_URI = "test_start_uri";
  final String PAGE_URI = "test_uri";
  final String LANGUAGE_NAME = "test_lang_name";
  final String LANGUAGE_CODE = "test_lang_code";
  final String LANGUAGE = "test_language";
  final String TASK_ID = "test_task_id";

  void run() {
    test.test('builder should create an app with defaults', () {
      var appUnderTest = new ApplicationBuilder(APP_NAME, APP_VERSION).build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.info.name, APP_NAME);
      test.expect(appUnderTest.info.author, test.isNull);
      test.expect(appUnderTest.info.startUri, test.isNull);
      test.expect(appUnderTest.info.language, Application.defaultLanguage);
      test.expect(appUnderTest.info.version, APP_VERSION);
      test.expect(appUnderTest.resources, test.isEmpty);
      test.expect(appUnderTest.pages, test.isEmpty);
      test.expect(appUnderTest.tasks, test.isEmpty);
      test.expect(appUnderTest.logger, test.isNull);
    });

    test.test('builder should create an app with all info', () {
      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..author = APP_AUTHOR
                                        ..language = LANGUAGE
                                        ..startUri = START_PAGE_URI)
                                        .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.info, test.isNotNull);
      test.expect(appUnderTest.info.name, APP_NAME);
      test.expect(appUnderTest.info.author, APP_AUTHOR);
      test.expect(appUnderTest.info.startUri, START_PAGE_URI);
      test.expect(appUnderTest.info.language, LANGUAGE);
      test.expect(appUnderTest.info.version, APP_VERSION);
    });

    test.test('builder should add logger', () {
      var appUnderTest = new ApplicationBuilder(APP_NAME, APP_VERSION, logger: new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION)).build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.logger, test.isNotNull);
      test.expect(appUnderTest.logger.applicationName, APP_NAME);
      test.expect(appUnderTest.logger.applicationVersion, APP_VERSION);
    });

    test.test('builder should log warning on duplicate', () {
      var loggerUnderTest = new Logger(
          applicationName: APP_NAME,
          applicationVersion: APP_VERSION,
          isSynchronouslyModeEnabled: true
      );

      var expectedPageCount = 1,
          expectedResourceCount = 1,
          expectedTaskCount = 1,
          expectedWarningCount = 6,
          expectedTaskWarningCount = 2,
          expectedResourceWarningCount = 2,
          expectedPageWarningCount = 2;

      var page1 = new ConfigPageModel()
        ..uri = PAGE_URI;
      var page2 = new ConfigPageModel()
        ..uri = PAGE_URI;
      var page3 = new ConfigPageModel()
        ..uri = PAGE_URI;

      var task1 = new ConfigTaskModel()
        ..name = TASK_ID;
      var task2 = new ConfigTaskModel()
        ..name = TASK_ID;
      var task3 = new ConfigTaskModel()
        ..name = TASK_ID;

      var res1 = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;
      var res2 = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;
      var res3 = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION, logger: loggerUnderTest)
                                        ..addPage(page1)
                                        ..addTask(task1)
                                        ..addResource(res1)
                                        ..addPage(page2)
                                        ..addTask(task2)
                                        ..addResource(res2)
                                        ..addPage(page3)
                                        ..addTask(task3)
                                        ..addResource(res3))
                                        .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.pages.length, expectedPageCount);
      test.expect(appUnderTest.tasks.length, expectedTaskCount);
      test.expect(appUnderTest.resources.length, expectedResourceCount);
      test.expect(appUnderTest.logger, test.isNotNull);
      test.expect(appUnderTest.logger.warningMessages, test.isNotNull);
      test.expect(appUnderTest.logger.warningMessages.length, expectedWarningCount);
      test.expect(appUnderTest.logger.warningMessages.where((message) => message is TaskExistsWarning).length, expectedTaskWarningCount);
      test.expect(appUnderTest.logger.warningMessages.where((message) => message is ResourceExistsWarning).length, expectedResourceWarningCount);
      test.expect(appUnderTest.logger.warningMessages.where((message) => message is PageExistsWarning).length, expectedPageWarningCount);
    });

    test.test('builder should add a page, task and resource', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;
      var task = new ConfigTaskModel()
        ..name = TASK_ID;
      var res = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..addPage(page)
                                        ..addTask(task)
                                        ..addResource(res))
                                        .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.resources, test.isNotNull);
      test.expect(appUnderTest.pages, test.isNotNull);
      test.expect(appUnderTest.tasks, test.isNotNull);
      test.expect(appUnderTest.resources.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.pages.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.tasks.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.resources[Resource.buildName(LANGUAGE_CODE, LANGUAGE_NAME)], test.isNotNull);
      test.expect(appUnderTest.pages[PAGE_URI], test.isNotNull);
      test.expect(appUnderTest.tasks[TASK_ID], test.isNotNull);

      test.schedule(() {
        return appUnderTest.start().then((_) {
          test.expect(appUnderTest.navigator, test.isNotNull);
          test.expect(appUnderTest.navigator.currentPage, test.isNotNull, reason: "start page is null");
          test.expect(appUnderTest.navigator.currentPage.uri, PAGE_URI);
        });
      });
    });

    test.test('builder should add a pages, tasks and resources', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;
      var task = new ConfigTaskModel()
        ..name = TASK_ID;
      var res = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..addPages(new List<Page>()..add(page))
                                        ..addTasks(new List<Task>()..add(task))
                                        ..addResources(new List<Resource>()..add(res)))
                                        .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.resources, test.isNotNull);
      test.expect(appUnderTest.pages, test.isNotNull);
      test.expect(appUnderTest.tasks, test.isNotNull);
      test.expect(appUnderTest.resources.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.pages.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.tasks.isNotEmpty, test.isTrue);
      test.expect(appUnderTest.resources[Resource.buildName(LANGUAGE_CODE, LANGUAGE_NAME)], test.isNotNull);
      test.expect(appUnderTest.pages[PAGE_URI], test.isNotNull);
      test.expect(appUnderTest.tasks[TASK_ID], test.isNotNull);

      test.schedule(() {
        return appUnderTest.start().then((_) {
          test.expect(appUnderTest.navigator, test.isNotNull);
          test.expect(appUnderTest.navigator.currentPage, test.isNotNull, reason: "start page is null");
          test.expect(appUnderTest.navigator.currentPage.uri, PAGE_URI);
        });
      });
    });

    test.test('builder should use URI of the first page as start URI using addPages(List)', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..addPages(new List<Page>()..add(page)))
                                        .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.info, test.isNotNull);
      test.expect(appUnderTest.info.startUri, PAGE_URI);
    });

    test.test('builder should use URI of the first page as start URI using addPage(Page)', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                          ..addPage(page))
                                          .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.info, test.isNotNull);
      test.expect(appUnderTest.info.startUri, PAGE_URI);
    });

    test.test('builder should use custom URI instead of the the URI of the first added page', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
        ..startUri = START_PAGE_URI
        ..addPage(page))
      .build();

      test.expect(appUnderTest, test.isNotNull);
      test.expect(appUnderTest.info, test.isNotNull);
      test.expect(appUnderTest.info.startUri, START_PAGE_URI);
    });
  }
}
