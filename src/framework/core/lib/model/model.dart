library modularity.core.model;

import 'dart:collection';

part 'meta_model.dart';
part 'config_model.dart';
part 'config_applications_model.dart';
part 'config_pages_model.dart';
part 'config_fragments_model.dart';
part 'config_modules_model.dart';
part 'config_resources_model.dart';

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