part of modularity.core;

class Resource {
  HashMap<String, String> _textResources;
  final String languageCode;
  final String languageName;
  String _name;

  Resource(this.languageCode, this.languageName) {
    _textResources = new HashMap<String, String>();
    _name = buildName(languageCode, languageName);
  }

  String get name => _name;

  void addText(String name, String value) {

  }

  static String buildName(String languageCode, String languageName) {
    return "${languageCode}_${languageName}";
  }
}
