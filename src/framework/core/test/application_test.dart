part of modularity.tests;

class ApplicationTest {
  final String APP_NAME = "test_app_name";
  final String APP_VERSION = "1.1.1";

  void run() {
    test.group('application tests', () {

      test.test('application should use defaults if application info is not valid', () {
        var appUnderTest = new Application(new ApplicationInfo(), new Navigator());

        test.expect(appUnderTest, test.isNotNull);
        test.expect(appUnderTest.info.name, Application.defaultName);
        test.expect(appUnderTest.info.author, test.isNull);
        test.expect(appUnderTest.info.startUri, test.isNull);
        test.expect(appUnderTest.info.language, Application.defaultLanguage);
        test.expect(appUnderTest.info.version, Application.defaultVersion);
        test.expect(appUnderTest.resources, test.isEmpty);
        test.expect(appUnderTest.pages, test.isEmpty);
        test.expect(appUnderTest.tasks, test.isEmpty);
        test.expect(appUnderTest.logger, test.isNull);
        test.expect(appUnderTest.navigator, test.isNotNull);
      });

      test.test('application should be initialized', () {
        var appInfo = new ApplicationInfo()
            ..name = APP_NAME
            ..version = APP_VERSION;

        var appUnderTest = new Application(appInfo, new Navigator());

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
        test.expect(appUnderTest.navigator, test.isNotNull);
      });



    });
  }

}