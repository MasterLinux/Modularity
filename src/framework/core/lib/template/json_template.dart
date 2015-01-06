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
  JsonTemplate(String template, String id, TemplateController controller, {Logger logger}) :
    super(template, id, controller, logger: logger);

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
      var converter = new JsonTemplateDataBindingConverter();

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

  JsonTemplateNode(String name, List<Map> attributes, {JsonTemplateNode parent, Logger logger}) :
    super(name, attributes, parent: parent, logger: logger);

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

/// Converts a JSON event [Map] to a [TemplateEvent].
///
/// Example JSON:
///     {
///       "type": "click",
///       "binding": {
///         "callback": "openPage",
///         "parameter": [{
///           "name": "uri",
///           "value": "home_uri"
///         }]
///       }
///     }
///
class JsonTemplateEventConverter extends Converter<Map, TemplateEvent> {
  static const String _mapKeyBinding = 'binding';
  static const String _mapKeyType = 'type';

  TemplateEvent convert(Map value) {
    var binding = new JsonTemplateEventBindingConverter().convert(value[_mapKeyBinding]);
    return new TemplateEvent(value[_mapKeyType], binding);
  }

  Map convertBack(TemplateEvent value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }
}

/// Converts a JSON event binding [Map] to a [TemplateEventBinding].
///
/// Example JSON:
///     {
///       "callback": "openPage",
///       "parameter": [{
///         "name": "uri",
///         "value": "home_uri"
///       }]
///     }
///
class JsonTemplateEventBindingConverter extends Converter<Map, TemplateEventBinding> {
  static const String _mapKeyCallback = 'callback';
  static const String _mapKeyParameter = 'parameter';
  static const String _mapKeyName = 'name';
  static const String _mapKeyValue = 'value';

  TemplateEventBinding convert(Map value) {
    var binding = new TemplateEventBinding(value[_mapKeyCallback]);

    for(var parameter in value[_mapKeyParameter]) {
      binding.parameter[parameter[_mapKeyName]] = parameter[_mapKeyValue];
    }

    return binding;
  }

  Map convertBack(TemplateEventBinding value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }
}

/// Converts a JSON event [Map] to a [TemplateDataBinding].
class JsonTemplateDataBindingConverter extends Converter<Map, TemplateDataBinding> {
  static const String _mapKeyAttribute = 'attribute';
  static const String _mapKeyProperty = 'property';

  TemplateDataBinding convert(Map value) {
    return new TemplateDataBinding(value[_mapKeyAttribute], value[_mapKeyProperty]);
  }

  Map convertBack(TemplateDataBinding value) {
    throw new UnimplementedError("Converting back to a JSON map isn't supported yet.");
  }
}
