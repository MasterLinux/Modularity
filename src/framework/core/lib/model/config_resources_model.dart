part of modularity.core.model;

class ConfigResourcesModel extends Model<ConfigResourceModel> {}

class ConfigResourceModel extends ObjectModel {
  String languageCode;
  String languageName;
  ConfigResourceResModel resource;
}

class ConfigResourceResModel {
  HashMap<String, String> text;
}

