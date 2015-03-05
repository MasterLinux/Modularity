import 'package:polymer/polymer.dart';
import 'dart:html' show Event, Node, CustomEvent;

@CustomTag('modularity-list')
class ModularityList extends PolymerElement {
  @observable List<String> listItems = toObservable([]);

  ModularityList.created() : super.created() {}
}