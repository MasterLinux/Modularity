library publizice.ui.tab_bar;

import 'package:polymer/polymer.dart';
import 'dart:html';

import 'publicize_tab_bar_item.dart';

@CustomTag('publicize-tab-bar')
class PublicizeTabBar extends PolymerElement {
  @published String onSelectionChanged;

  static const String ATTRIBUTE_SELECTED_INDEX = 'selectedindex';

  /**
   * ID of the content element which contains
   * all tab bar items
   */
  static const String _ID_CONTENT = 'items';

  /**
   * Default index of the initial selected item
   */
  static const String _INDEX_DEFAULT = '0';

  /**
   * The local name od this element
   */
  static const String ELEMENT_NAME = 'publicize-tab-bar';

  /**
   * Initializes the tab bar
   */
  PublicizeTabBar.created() : super.created() {
    var selectedIndex = _selectedIndex;

    //initializes all items
    for(var idx=0; idx<items.length; idx++) {
      var item = items[idx];

      item.attributes[PublicizeTabBarItem.ATTRIBUTE_INDEX] = idx.toString();

      if(selectedIndex == idx) {
        item.attributes[PublicizeTabBarItem.ATTRIBUTE_SELECTED] = 'true';
      }
    }
  }

  void attributeChanged(String name, String oldValue, String newValue) {
    switch(name) {
      case ATTRIBUTE_SELECTED_INDEX:

        //get previous selected item
        var el = items.firstWhere((e) {
          return e.attributes[PublicizeTabBarItem.ATTRIBUTE_INDEX] == oldValue;
        });

        if(el != null) {
          el.attributes.remove(PublicizeTabBarItem.ATTRIBUTE_SELECTED);
        }
        break;
    }
  }

  /**
   * Gets all tab bar items
   */
  List<Element> get items {
    var nodes = (this.$[_ID_CONTENT] as ContentElement).getDistributedNodes();

    return nodes.where((e) {
      return e != null && e.localName == PublicizeTabBarItem.ELEMENT_NAME;
    }).toList();
  }

  /**
   * Gets the value of the selectedIndex attribute
   */
  int get _selectedIndex {
    var selectedIndexAttr = this.attributes[ATTRIBUTE_SELECTED_INDEX];
    int selectedIndex = int.parse(selectedIndexAttr != null ? selectedIndexAttr : _INDEX_DEFAULT);
    return selectedIndex;
  }

}
