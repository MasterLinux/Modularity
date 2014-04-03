import 'package:polymer/polymer.dart';
import 'dart:html';

class PublicizeMenuItem {
  String title;
  int id;

  PublicizeMenuItem(this.title, this.id);
}

@CustomTag('publicize-tab-bar')
class PublicizeTabBar extends PolymerElement {
  @observable List<PublicizeMenuItem> menuItems;
  @published int selection;
  @published String items;

  /**
   * Initializes the tab bar
   */
  PublicizeTabBar.created() : super.created() {
    menuItems = [];

    if(items != null) {
      var i = items.split(",");
      var idx = 0;

      for(var item in i) {
        menuItems.add(new PublicizeMenuItem(++idx, item));
      }
    }
  }

  void onSelectionChanged(Event e, var detail, Node target) {

  }
}
