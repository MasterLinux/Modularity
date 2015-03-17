library modularity.core.manifest;

import 'data/data.dart' show Converter;

class Manifest {

  Manifest.fromJson(String json) {

  }


}



//################################## view template
class ViewTemplateModel {
  String lib;
  String type;
  List<ViewBindingModel> attributes;
  List<ViewBindingModel> events;
  List<ViewTemplateModel> subviews;
}

class ViewBindingModel {
  String attributeName;
  String propertyName;
  dynamic defaultValue;
}

class ViewTemplateConverter implements Converter<Map, ViewTemplateModel> {
  static const String attributesKey = "attributes";
  static const String subviewsKey = "subviews";
  static const String eventsKey = "events";
  static const String libraryKey = "lib";
  static const String typeKey = "type";
  static const String nameKey = "name";
  static const String valueKey = "value";
  static const String bindingKey = "binding";

  @override
  ViewTemplateModel convert(Map jsonMap) {
    var attributes = new List<ViewBindingModel>();
    var events = new List<ViewBindingModel>();
    var subviews = new List<ViewTemplateModel>();

    var libraryName = jsonMap[libraryKey];
    var viewType = jsonMap[typeKey];

    var attributesList = jsonMap[attributesKey];
    if(attributesList != null && attributesList is List) {
      for(var attribute in attributesList) {
        attributes.add(_parseAttributeBinding(attribute));
      }
    }

    var eventsList = jsonMap[eventsKey];
    if(eventsList != null && eventsList is List) {
      for(var event in eventsList) {
        events.add(_parseEventHandlerBinding(event));
      }
    }

    var subviewsList = jsonMap[subviewsKey];
    if(subviewsList != null && subviewsList is List) {
      for(var subview in subviewsList) {
        subviews.add(convert(subview));
      }
    }

    return new ViewTemplateModel()
      ..lib = libraryName
      ..type = viewType
      ..attributes = attributes
      ..events = events
      ..subviews = subviews;
  }

  ViewBindingModel _parseEventHandlerBinding(Map event) {
    var eventHandlerName = event[nameKey];
    var propertyName = event[bindingKey];

    return new ViewBindingModel()
      ..attributeName = eventHandlerName
      ..propertyName = propertyName;
  }

  ViewBindingModel _parseAttributeBinding(Map attribute) {
    var attributeName = attribute[nameKey];
    var propertyName = attribute[bindingKey];
    var defaultValue = attribute[valueKey];

    return new ViewBindingModel()
      ..attributeName = attributeName
      ..propertyName = propertyName
      ..defaultValue = defaultValue;
  }

  @override
  Map convertBack(ViewTemplateModel value) {
    throw new UnimplementedError();
  }

}

