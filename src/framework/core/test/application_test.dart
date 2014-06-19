part of modularity.tests;

class ApplicationTest {
  final int PAGE_COUNT = 2;
  Application appUnderTest;
  Application appWithoutDataUnderTest;
  ConfigLoader configLoader;
  ConfigLoader configLoaderWithoutData;

  void run() {
    group('application tests', () {

      test('app should not be initialized before started', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock(),
            isInDebugMode: false
        );

        expect(appUnderTest.name, isNull);
        expect(appUnderTest.author, isNull);
        expect(appUnderTest.startUri, isNull);
        expect(appUnderTest.language, isNull);
        expect(appUnderTest.version, isNull);
        expect(appUnderTest.resources, isEmpty);
        expect(appUnderTest.pages, isEmpty);
        expect(appUnderTest.tasks, isEmpty);
      });

      test('app should be initialized after started', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock(),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() {
          return appUnderTest.start().then((data) {
            expect(appUnderTest.pages, isNotNull);
            expect(appUnderTest.pages, hasLength(ConfigLoaderMock.PAGE_COUNT));

            expect(appUnderTest.tasks, isNotNull);
            expect(appUnderTest.tasks, hasLength(ConfigLoaderMock.TASK_COUNT));

            expect(appUnderTest.resources, isNotNull);
            expect(appUnderTest.resources, hasLength(ConfigLoaderMock.RESOURCE_COUNT));

            expect(appUnderTest.name, ConfigLoaderMock.APPLICATION_NAME);
            expect(appUnderTest.author, ConfigLoaderMock.APPLICATION_AUTHOR);
            expect(appUnderTest.language, ConfigLoaderMock.APPLICATION_LANGUAGE);
            expect(appUnderTest.version, ConfigLoaderMock.APPLICATION_VERSION);
            expect(appUnderTest.startUri, ConfigLoaderMock.APPLICATION_START_URI);

            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

      test('start should throw if no page is defined', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock.exclude(pages: true),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() {
          return appUnderTest.start().catchError((error) {
            expect(error, new isInstanceOf<ApplicationLoadingException>('ApplicationLoadingException'));
          });
        });
      });

      test('name should be optional', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock.exclude(name: true),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() {
          return appUnderTest.start().then((data) {
            expect(appUnderTest.name, isNull);
            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

      test('version should be optional', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock.exclude(version: true),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() {
          return appUnderTest.start().then((data) {
            expect(appUnderTest.version, isNull);
            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

    });
  }

}