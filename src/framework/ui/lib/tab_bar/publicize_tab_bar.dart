library publizice.ui.tab_bar;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('publicize-tab-bar')
class PublicizeTabBar extends PolymerElement {
  @published String onSelectionChanged;

  /**
   * Local name of a tab bar item element
   */
  static const String _ELEMENT_TAB_BAR_ITEM = 'publicize-tab-bar-item';

  /**
   * Index attribute
   */
  static const String _ATTRIBUTE_INDEX = 'index';

  static const String _ATTRIBUTE_SELECTED_INDEX = 'selectedindex';

  /**
   * ID of the content element which contains
   * all tab bar items
   */
  static final String _ID_CONTENT = 'items';

  /**
   * Initializes the tab bar
   */
  PublicizeTabBar.created() : super.created() {
    //initializes all items
    for(var idx=0; idx<items.length; idx++) {
      items[idx].attributes[_ATTRIBUTE_INDEX] = idx.toString();
    }
  }

  void attributeChanged(String name, String oldValue, String newValue) {
    switch(name) {
      case _ATTRIBUTE_SELECTED_INDEX:
        var el = items.firstWhere((e) {
          return e.attributes[_ATTRIBUTE_INDEX] == oldValue;
        });

        if(el != null) {
          el.attributes.remove('selected');
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
      return e != null && e.localName == _ELEMENT_TAB_BAR_ITEM;
    }).toList();
  }

}
