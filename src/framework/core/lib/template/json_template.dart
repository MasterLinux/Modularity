part of modularity.core.template;

/// Template which converts a JSON template string into a Template.
///
/// Example:
///     var template = new JsonTemplate(
///     '''
///     {
///       "type": "StackPanel",
///       "attributes": [{
///         "name": "orientation",
///         "value": "horizontal"
///       }],
///       "children": [{
///         "type": "Button",
///         "attributes": [{
///           "name": "title",
///           "value": "Cancel"
///         }],
///         "children": []
///       }, {
///         "type": "Button",
///         "attributes": [{
///           "name": "title",
///           "value": "OK"
///         }],
///         "children": []
///       }]
///     }
///     '''
///     );
///
///     // The TemplateNode which can be converted
///     // to a HTML node
///     var node = template.node;
///
abstract class JsonTemplate extends Template<String> {

  /// Initializes the [JsonTemplate] with the help of
  /// a JSON [template] string
  JsonTemplate(String template, {Logger logger}) :
    super(template, logger: logger);

  TemplateNodeConverter get nodeConverter => new JsonTemplateNodeConverter(logger);
}


/// Converts a JSON template string into a [TemplateNode]
class JsonTemplateNodeConverter extends TemplateNodeConverter<String> {
  static const String _mapKeyAttributes = 'attributes';
  static const String _mapKeyChildren = 'children';
  static const String _mapKeyBindings = 'bindings';
  static const String _mapKeyEvents = 'events';
  static const String _mapKeyType = 'type';
  final Logger logger;

  /// Initializes the converter
  JsonTemplateNodeConverter(this.logger);

  TemplateNode convert(String value) {
    var template = JSON.decode(value);
    return _convert(template);
  }

  String convertBack(TemplateNode value) {
    throw new UnimplementedError("Converting back to a JSON string isn't supported yet.");
  }

  TemplateNode _convert(Map template, {TemplateNode parent}) {
    var children = template[_mapKeyChildren];
    var bindings = template[_mapKeyBindings];
    var events = template[_mapKeyEvents];

    var node = new JsonTemplateNode(
        template[_mapKeyType],
        template[_mapKeyAttributes],
        parent: parent, logger: logger
    );

    // add all event-bindings
    if(events != null) {
      var converter = new JsonTemplateEventConverter();

      for(var event in events) {
        node.events.add(converter.convert(event));
      }
    }

    // add all data-bindings
    if(bindings != null) {
      var converter = new JsonTemplateBindingConverter();

      for(var binding in bindings) {
        node.bindings.add(converter.convert(binding));
      }
    }

    // add all children nodes
    for(var child in children) {
      node.children.add(_convert(child));
    }

    return node;
  }
}

/// Represents a JSON [TemplateNode]
class JsonTemplateNode extends TemplateNode<Map> {
  final List<JsonTemplateBinding> bindings;
  final List<JsonTemplateEvent> events;

  JsonTemplateNode(String name, List<Map> attributes, {JsonTemplateNode parent, Logger logger}) :
    super(name, attributes, parent: parent, logger: logger),
    bindings = new List<JsonTemplateBinding>(),
    events = new List<JsonTemplateEvent>();

  TemplateAttributeConverter get attributeConverter => new JsonTemplateAttributeConverter(logger);
}


/// Converts a JSON object represented by a [Map] into an attribute
class JsonTemplateAttributeConverter extends TemplateAttributeConverter<Map> {
  static const String _mapKeyValue = 'value';
  static const String _mapKeyName = 'name';
  final Logger logger;

  JsonTemplateAttributeConverter(this.logger);

  TemplateAttribute convert(Map value) {
    return new JsonTemplateAttribute(
      value[_mapKeyName],
      value[_mapKeyValue],
      logger: logger
    );
  }

  Map convertBack(TemplateAttribute value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }
}

/// Represents a JSON [TemplateAttribute]
class JsonTemplateAttribute extends TemplateAttribute<String> {

  JsonTemplateAttribute(String name, String value, {Logger logger}) :
    super(name, value, logger: logger);
}

/// Converts a JSON event map to a [JsonTemplateEvent].
///
/// Example:
///     //TODO describe input JSON
///     var event = new JsonTemplateEventConverter().convert(eventJsonMap);
///
class JsonTemplateEventConverter extends Converter<Map, JsonTemplateEvent> {
  static const String _mapKeyBinding = 'binding';
  static const String _mapKeyType = 'type';

  JsonTemplateEvent convert(Map value) {
    return new JsonTemplateEvent(value[_mapKeyType])
      ..parameter.addAll(parseParameterList(value[_mapKeyBinding]));
  }

  Map convertBack(JsonTemplateEvent value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }

  /// Parses the [parameterList] string to a [List] of [JsonTemplateEventParameter]
  /// The [] string looks like the following string `#openPage(index:#index=1,element:#el)`
  List<JsonTemplateEventParameter> parseParameterList(String parameterList) {
    var list = new List<JsonTemplateEventParameter>();



    return list; //TODO implement parser
  }
}


class JsonTemplateEvent {
  final String callbackName;
  final List<JsonTemplateEventParameter> parameter;

  JsonTemplateEvent(this.callbackName) :
    parameter = new List<JsonTemplateEventParameter>();

  void parseParameterList(String parameterList) {

  }
}

class JsonTemplateEventParameter {
  final String propertyName;
  final String type;
  final String value;

  JsonTemplateEventParameter(this.propertyName, this.type, this.value);
}


class JsonTemplateBindingConverter extends Converter<Map, JsonTemplateBinding> {
  static const String _mapKeyAttribute = 'attribute';
  static const String _mapKeyProperty = 'property';

  JsonTemplateBinding convert(Map value) {
    return new JsonTemplateBinding(value[_mapKeyAttribute], value[_mapKeyProperty]);
  }

  Map convertBack(JsonTemplateBinding value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }
}

class JsonTemplateBinding {
  final String attributeName;
  final String propertyName;

  JsonTemplateBinding(this.attributeName, this.propertyName);
}
