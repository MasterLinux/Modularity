part of modularity.core;

/**
 * An application context which
 * is an interface to all global
 * information
 */
class ApplicationContext {
  final Application application;

  ApplicationContext(this.application);

  String get applicationName => application.name;
}