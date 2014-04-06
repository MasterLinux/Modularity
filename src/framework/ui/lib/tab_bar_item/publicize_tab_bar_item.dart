library publizice.ui.tab_bar_item;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('publicize-tab-bar-item')
class PublicizeTabBarItem extends PolymerElement {
  @published bool isSelected;
  @published String uri;
  @published int index;

  PublicizeTabBarItem.created() : super.created();

  void attributeChanged(String name, String oldValue, String newValue) {
    switch(name) {
      case 'selected':
        //deselect item when attribute is removed
        if(newValue == null) {
          _setSelected(false);
        }
        break;
    }
  }

  void select(Event e, var detail, LIElement target) {
    this.attributes['selected'] = 'true';
    var tabIndex = int.parse(target.attributes["index"]);
    setTabSelection(tabIndex);
  }

  /**
   * Gets the parent tab bar
   */
  Element getTabBar() {
    return this.parent != null &&
        this.parent.localName == "publicize-tab-bar" ?
        this.parent :
        null;
  }

  void _setSelected(bool isSelected) {

  }

  /**
   * Updates
   */
  void setTabSelection(int tabIndex) {
    Element tabBar;

    if((tabBar = getTabBar()) != null) {
      tabBar.attributes["selectedindex"] = tabIndex.toString();
    }
  }
}
