part of lib.core;

class Application {
  Completer _startCompleter = new Completer();

  final ConfigApplicationModel config;

  final int LOADING_PROGRESS_INITIAL = 0;

  final int LOADING_PROGRESS_COMPLETED = 100;

  /**
   * Initializes the application
   */
  Application(this.config);

  /**
   * Creates the application with the help
   * of the given config and starts it
   */
  Future start() { //TODO return a feature to get informed on loading progress

    new Future(() => _initialize())
      .then(() => _startCompleter.complete())
      .catchError((e) => _startCompleter.completeError(e));

    return _startCompleter.future;
  }

  /**
   * Destructs and stops the application
   */
  void stop() {
    //TODO destroy application
  }

  void _initialize() {

  }

  /**
   * Event handler which is invoked whenever the
   * loading progress of the application changed
   */
  void _onLoadingProgressChange(int progress) {
    switch(progress) {
      case LOADING_PROGRESS_INITIAL:
        break;

      case LOADING_PROGRESS_COMPLETED:
        _startCompleter.complete();
        break;

      default:
        break;
    }
    //TODO invoke loading indicator?
  }
}
