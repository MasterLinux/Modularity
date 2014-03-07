library lib.core.model;

part 'meta_model.dart';
part 'config_model.dart';
part 'config_page_model.dart';
part 'config_fragment_model.dart';
part 'config_module_model.dart';

/**
 * Base implementation of a model.
 */
abstract class Model<T extends ObjectModel> {
  MetaModel meta;
  List<T> objects;
}

/**
 * Base implementation of a response result.
 */
abstract class ObjectModel {
  int id;
  String resourceUri;
}