part of lib.core;

class Application {
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
  void start() {
    _onLoadingProgressChange(LOADING_PROGRESS_INITIAL);

    //TODO implement module loading

    _onLoadingProgressChange(LOADING_PROGRESS_COMPLETED);
  }

  /**
   * Destructs and stops the application
   */
  void stop() {
    //TODO destroy application
  }

  /**
   * Event handler which is invoked whenever the
   * loading progress of the application changed
   */
  void _onLoadingProgressChange(int progress) {
    //TODO invoke loading indicator?
  }
}
