part of modularity.tests;

class ApplicationTest {
  final int PAGE_COUNT = 2;
  Application appUnderTest;
  Application appWithoutDataUnderTest;
  ConfigLoader configLoader;
  ConfigLoader configLoaderWithoutData;

  void run() {
    group('application tests', () {

      test('test app should not be initialized before started', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock(),
            isInDebugMode: false
        );

        expect(appUnderTest.name, isNull);
        expect(appUnderTest.author, isNull);
        expect(appUnderTest.startUri, isNull);
        expect(appUnderTest.language, isNull);
        expect(appUnderTest.version, isNull);
        //expect(application.resources, isNull);
        expect(appUnderTest.pages, isNull);
        //expect(application.tasks, isNull);
      });

      test('test app should be initialized after started', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock(),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() {
          return appUnderTest.start().then((data) {
            expect(appUnderTest.pages, isNotNull);
            expect(appUnderTest.pages, hasLength(ConfigLoaderMock.PAGE_COUNT));
            expect(appUnderTest.name, ConfigLoaderMock.APPLICATION_NAME);
            expect(appUnderTest.author, ConfigLoaderMock.APPLICATION_AUTHOR);
            expect(appUnderTest.language, ConfigLoaderMock.APPLICATION_LANGUAGE);
            expect(appUnderTest.version, ConfigLoaderMock.APPLICATION_VERSION);
            expect(appUnderTest.startUri, ConfigLoaderMock.APPLICATION_START_URI);
            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

      test('test name is optional', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock.exclude(name: true),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() { //TODO test whether function throws
          return appUnderTest.start().then((data) {
            expect(appUnderTest.name, isNull);
            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

      test('test version is optional', () {
        var appUnderTest = new Application(
            configLoaderFactory: () => new ConfigLoaderMock.exclude(version: true),
            isInDebugMode: false
        );

        expect(appUnderTest.isStarted, isFalse);

        schedule(() { //TODO test whether function throws
          return appUnderTest.start().then((data) {
            expect(appUnderTest.version, isNull);
            expect(appUnderTest.isStarted, isTrue);
          });
        });

      });

    });
  }

}