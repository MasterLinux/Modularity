part of modularity.tests;

class ApplicationTest {
  final int PAGE_COUNT = 2;
  Application appUnderTest;
  ConfigLoader configLoader;

  void run() {
    group('application tests', () {
      setUp(() {
        configLoader = new ConfigLoaderMock();
        appUnderTest = new Application(
            configLoaderFactory: () => configLoader,
            isInDebugMode: false
        );
      });

      /* tearDown(() {
        appUnderTest = null;
      });*/

      test('test preconditions', () {
        expect(configLoader, isNotNull);
        expect(appUnderTest, isNotNull);
      });

      test('test app should not be initialized before started', () {
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

        schedule(() {
          return appUnderTest.start().then((data) {
            expect(appUnderTest.pages, isNotNull);
            expect(appUnderTest.pages, hasLength(ConfigLoaderMock.PAGE_COUNT));
          });
        });



        //schedule();


        //expect(future, completes);
/*
        //test application
        expect(appUnderTest.pages, isNotNull);
        expect(appUnderTest.pages, hasLength(PAGE_COUNT));

        //TODO expectAsync?
*/
      });

    });
  }

}