part of modularity.core.template;

///
class JsonTemplate extends Template<String> {

  JsonTemplate(String template, {Logger: logger}) :
    super(template, logger: logger);

  TemplateNodeConverter get nodeConverter => new JsonTemplateNodeConverter(logger);
}

class JsonTemplateNodeConverter extends TemplateNodeConverter<String> {
  static const String _mapKeyAttributes = 'attributes';
  static const String _mapKeyChildren = 'children';
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
    var node = new JsonTemplateNode(
        template[_mapKeyType],
        template[_mapKeyAttributes],
        parent: parent, logger: logger
    );

    for(var child in children) {
      node.children.add(_convert(child));
    }

    return node;
  }
}

class JsonTemplateNode extends TemplateNode<Map> {

  JsonTemplateNode(String name, List<Map> attributes, {JsonTemplateNode parent, Logger logger: logger}) :
    super(name, attributes, parent: parent, logger: logger);

  TemplateAttributeConverter get attributeConverter => new JsonTemplateAttributeConverter(logger);
}

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

class JsonTemplateAttribute extends TemplateAttribute<String> {

  JsonTemplateAttribute(String name, String value, {Logger logger}) :
    super(name, value, logger: logger);

}