library publizice.ui.tab_bar_item;

import 'package:polymer/polymer.dart';
import 'dart:html';

import 'publicize_tab_bar.dart';

@CustomTag('publicize-tab-bar-item')
class PublicizeTabBarItem extends PolymerElement {
  @published bool isSelected;
  @published String uri;
  @published int index;

  /**
   * The local name od this element
   */
  static const String ELEMENT_NAME = 'publicize-tab-bar-item';

  static const String ATTRIBUTE_INDEX = 'index';

  static const String ATTRIBUTE_SELECTED = 'selected';

  static const String CSS_SELECTED = 'selected';

  PublicizeTabBarItem.created() : super.created();

  /**
   * Handler which is invoked whenever an attribute is changed
   */
  void attributeChanged(String name, String oldValue, String newValue) {
    switch(name) {
      case ATTRIBUTE_SELECTED:
        //deselect item when attribute is removed
        if(newValue == null) {
          _setSelected(false);
        }

        break;
    }
  }

  /**
   * Event handler, used to select this element
   */
  void select(Event e, var detail, LIElement target) {
    var tabIndex = int.parse(target.attributes[ATTRIBUTE_INDEX]);
    _setTabIndex(tabIndex);
    _setSelected(true);
  }

  /**
   * Gets the parent tab bar
   */
  Element getTabBar() {
    return this.parent != null &&
        this.parent.localName == PublicizeTabBar.ELEMENT_NAME ?
        this.parent :
        null;
  }

  /**
   * Selects or deselects this element
   */
  void _setSelected(bool isSelected) {
    if(isSelected) {
      this.attributes[ATTRIBUTE_SELECTED] = 'true';
      this.classes.add(CSS_SELECTED);
    } else {
      this.classes.remove(CSS_SELECTED);
    }
  }

  /**
   * Sets the tab index
   */
  void _setTabIndex(int tabIndex) {
    Element tabBar;

    if((tabBar = getTabBar()) != null) {
      tabBar.attributes[PublicizeTabBar.ATTRIBUTE_SELECTED_INDEX] = tabIndex.toString();
    }
  }
}
