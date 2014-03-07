part of lib.core.model;

class ConfigPagesModel extends Model<ConfigPageModel>{}

class ConfigPageModel extends ObjectModel {
  String uri;
  String title;
  bool isDefault;
  List<ConfigFragmentModel> fragments;
}
