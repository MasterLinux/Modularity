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

/**
 * Warning which is used whenever a resource already exists
 */
class ResourceExistsWarning extends utility.WarningMessage {
  final String _name;

  ResourceExistsWarning(String namespace, String name) : _name = name, super(namespace);

  @override
  String get message =>
  "Resource with name => \"$_name\" already exists. You have to fix the name duplicate to ensure that the application works as expected.";
}
