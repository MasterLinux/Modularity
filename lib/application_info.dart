part of modularity.core;

/**
 * Representation of a language
 *
 *     //
 *     var german = new Language.fromCode("de_DE");
 *     var english = new Language.fromCode("en-US");
 *     var defaultLanguage = new Language();
 */
class Language {
  static const String defaultLanguage = "en";
  static const String defaultCountry = "US";

  String _language;
  String _country;

  Language.fromCode(String code) {
    var info = _parse(code);

    _language = info.language;
    _country = info.country;
  }

  Language({String language:defaultLanguage, String country:defaultCountry}) {
    _language = language;
    _country = country;
  }

  String get language => _language;

  String get country => _country;

  Language _parse(String code) {
    return new Language(language:"bla");
    //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${language}-${country}";
}

/**
 * Representation of a version
 *
 *     var version = new Version.fromString("1.2.43");
 *     var version = new Version.fromString("1.2.43_version-name");
 *
 */
class Version {
  static const String defaultMajor = "1";
  static const String defaultMinor = "0";
  static const String defaultMaintenance = "0";

  String _major;
  String _minor;
  String _maintenance;
  String _name;

  Version.fromString(String versionString) {
    var info = _parse(versionString);

    _major = info.major;
    _minor = info.minor;
    _maintenance = info.maintenance;
    _name = info.name;
  }

  Version({String major:defaultMajor, String minor:defaultMinor, String maintenance:defaultMaintenance, String name}) {
    _major = major;
    _minor = minor;
    _maintenance = maintenance;
    _name = name;
  }

  String get major => _major;

  String get minor => _minor;

  String get maintenance => _maintenance;

  String get name => _name;

  Version _parse(String version) {
    return new Version();
    //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${major}.${minor}.${maintenance}";
//TODO add version name if set
}

class Author {
  final String firstName;
  final String lastName;

  //TODO add company as new model class
  //TODO add email

  Author(this.firstName, this.lastName);
}

class MissingApplicationNameError extends utility.ErrorMessage {
  MissingApplicationNameError(String namespace) : super(namespace);

  @override
  String get message =>
  "Application name is missing. You have to set a name to ensure that your application runs correctly.";
}

class MissingApplicationVersionError extends utility.ErrorMessage {
  MissingApplicationVersionError(String namespace) : super(namespace);

  @override
  String get message =>
  "Application version is missing. You have to set a version number to ensure that your application runs correctly.";
}

class MissingStartUriError extends utility.ErrorMessage {
  MissingStartUriError(String namespace) : super(namespace);

  @override
  String get message =>
  "Start URI is missing. You have to set a start URI or have to add a page to ensure that your application runs correctly.";
}

class MissingDefaultLanguageWarning extends utility.WarningMessage {
  MissingDefaultLanguageWarning(String namespace) : super(namespace);

  @override
  String get message =>
  "Application Language is not set. So it will be fall back to the default language.";
}
