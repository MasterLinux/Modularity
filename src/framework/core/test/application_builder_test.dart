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
    test('builder should create an app with defaults', () {
      var appUnderTest = new ApplicationBuilder(APP_NAME, APP_VERSION).build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.info.name, APP_NAME);
      expect(appUnderTest.info.author, isNull);
      expect(appUnderTest.info.startUri, isNull);
      expect(appUnderTest.info.language, Application.DEFAULT_LANGUAGE);
      expect(appUnderTest.info.version, APP_VERSION);
      expect(appUnderTest.resources, isEmpty);
      expect(appUnderTest.pages, isEmpty);
      expect(appUnderTest.tasks, isEmpty);
      expect(appUnderTest.logger, isNull);
    });

    test('builder should create an app with all info', () {
      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..author = APP_AUTHOR
                                        ..language = LANGUAGE
                                        ..startUri = START_PAGE_URI)
                                        .build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.info, isNotNull);
      expect(appUnderTest.info.name, APP_NAME);
      expect(appUnderTest.info.author, APP_AUTHOR);
      expect(appUnderTest.info.startUri, START_PAGE_URI);
      expect(appUnderTest.info.language, LANGUAGE);
      expect(appUnderTest.info.version, APP_VERSION);
    });

    test('builder should add logger', () {
      var appUnderTest = new ApplicationBuilder(APP_NAME, APP_VERSION, logger: new Logger(applicationName: APP_NAME, applicationVersion: APP_VERSION)).build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.logger, isNotNull);
      expect(appUnderTest.logger.applicationName, APP_NAME);
      expect(appUnderTest.logger.applicationVersion, APP_VERSION);
    });

    test('builder should log warning on duplicate', () {
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

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.pages.length, expectedPageCount);
      expect(appUnderTest.tasks.length, expectedTaskCount);
      expect(appUnderTest.resources.length, expectedResourceCount);
      expect(appUnderTest.logger, isNotNull);
      expect(appUnderTest.logger.warningMessages, isNotNull);
      expect(appUnderTest.logger.warningMessages.length, expectedWarningCount);
      expect(appUnderTest.logger.warningMessages.where((message) => message is BackgroundTaskExistsWarning).length, expectedTaskWarningCount);
      expect(appUnderTest.logger.warningMessages.where((message) => message is ResourceExistsWarning).length, expectedResourceWarningCount);
      expect(appUnderTest.logger.warningMessages.where((message) => message is PageExistsWarning).length, expectedPageWarningCount);
    });

    test('builder should add a page, task and resource', () {
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

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.resources, isNotNull);
      expect(appUnderTest.pages, isNotNull);
      expect(appUnderTest.tasks, isNotNull);
      expect(appUnderTest.resources.isNotEmpty, isTrue);
      expect(appUnderTest.pages.isNotEmpty, isTrue);
      expect(appUnderTest.tasks.isNotEmpty, isTrue);
      expect(appUnderTest.resources[Resource.buildName(LANGUAGE_CODE, LANGUAGE_NAME)], isNotNull);
      expect(appUnderTest.pages[PAGE_URI], isNotNull);
      expect(appUnderTest.tasks[TASK_ID], isNotNull);
    });

    test('builder should add a pages, tasks and resources', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;
      var task = new ConfigTaskModel()
        ..name = TASK_ID;
      var res = new ConfigResourceModel()
        ..languageName = LANGUAGE_NAME
        ..languageCode = LANGUAGE_CODE;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..addPages(new List<Page>()..add(page))
                                        ..addTasks(new List<BackgroundTask>()..add(task))
                                        ..addResources(new List<Resource>()..add(res)))
                                        .build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.resources, isNotNull);
      expect(appUnderTest.pages, isNotNull);
      expect(appUnderTest.tasks, isNotNull);
      expect(appUnderTest.resources.isNotEmpty, isTrue);
      expect(appUnderTest.pages.isNotEmpty, isTrue);
      expect(appUnderTest.tasks.isNotEmpty, isTrue);
      expect(appUnderTest.resources[Resource.buildName(LANGUAGE_CODE, LANGUAGE_NAME)], isNotNull);
      expect(appUnderTest.pages[PAGE_URI], isNotNull);
      expect(appUnderTest.tasks[TASK_ID], isNotNull);
    });

    test('builder should use URI of the first page as start URI using addPages(List)', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                        ..addPages(new List<Page>()..add(page)))
                                        .build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.info, isNotNull);
      expect(appUnderTest.info.startUri, PAGE_URI);
    });

    test('builder should use URI of the first page as start URI using addPage(Page)', () {
      var page = new ConfigPageModel()
        ..uri = PAGE_URI;

      var appUnderTest = (new ApplicationBuilder(APP_NAME, APP_VERSION)
                                          ..addPage(page))
                                          .build();

      expect(appUnderTest, isNotNull);
      expect(appUnderTest.info, isNotNull);
      expect(appUnderTest.info.startUri, PAGE_URI);
    });
  }
}
