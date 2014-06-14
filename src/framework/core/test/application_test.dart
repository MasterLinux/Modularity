part of lib.test;

class ApplicationTest {
  static Application application;
  static ConfigLoader configLoader;

  static void run() {
    group('application tests', () {
      setUp(() {
        application = new Application(() => configLoader, isInDebugMode: false);
      });

      tearDown(() {
        application = null;
      });

      test('test preconditions', () {
        expect(configLoader, isNotNull);
        expect(application, isNotNull);
      });

    });
  }

}