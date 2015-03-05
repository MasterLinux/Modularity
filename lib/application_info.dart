part of modularity.core;

/**
 * Representation of a language
 *
 *   //
 *   var german = new Language.fromCode("de_DE");
 *   var english = new Language.fromCode("en-US");
 *   var defaultLanguage = new Language();
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

  factory Language({String language:defaultLanguage, String country:defaultCountry}) {
    return new Language.fromCode("${language}-${country}");
  }

  String get language => _language;

  String get country => _country;

  Language _parse(String code) {
    return null; //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${language}-${country}";
}

/**
 * Representation of a version
 *
 *   var version = new Version.fromString("1.2.43");
 *   var version = new Version.fromString("1.2.43_version-name");
 *
 */
class Version {
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

  String get major => _major;

  String get minor => _minor;

  String get maintenance => _maintenance;

  String get name => _name;

  Version _parse(String version) {
    return null; //TODO see https://pub.dartlang.org/packages/peg
  }

  String toString() => "${major}.${minor}.${maintenance}"; //TODO add version name if set
}

class Author {
  final String firstName;
  final String lastName;
  //TODO add company as new model class
  //TODO add email

  Author(this.firstName, this.lastName);
}