part of modularity.core.template;

class PageTemplate extends Template<XmlElement> {

  PageTemplate(String xmlTemplate, {Logger logger}) :
  super(parse(xmlTemplate).rootElement, logger: logger);

  TemplateNodeConverter get nodeConverter => new PageTemplateNodeConverter(logger:logger);
}


/// converter

/// Converter used to convert a [XmlElement] to a [TemplateNode]
class PageTemplateNodeConverter extends TemplateNodeConverter<XmlElement> {
  final Logger logger;

  PageTemplateNodeConverter({this.logger});

  /// Converts a [XmlElement] to a [TemplateNode]
  TemplateNode convert(XmlElement value) {
    return _convert(value);
  }

  TemplateNode _convert(XmlElement xmlElement, {TemplateNode parent}) {
    var node = _createNode(xmlElement, parent);

    for(var child in xmlElement.children) {
      if(child.nodeType == XmlNodeType.ELEMENT) {
        node.children.add(_convert(child, parent: node));
      }
    }

    return node;
  }

  TemplateNode _createNode(XmlElement xmlElement, TemplateNode parent) {
    TemplateNode node;

    switch(xmlElement.name.local) {
      case VerticalNode.xmlName:
        node = new VerticalNode(xmlElement, parent, logger: logger);
        break;

      case HorizontalNode.xmlName:
        node = new HorizontalNode(xmlElement, parent, logger: logger);
        break;

      default:
        node = new PageNode(xmlElement, parent, logger: logger);
        break;
    }

    return node;
  }

  /// This method isn't implemented yet. It throws an exception
  XmlElement convertBack(TemplateNode value) {
    throw new UnimplementedError("Converting back to a XML element isn't supported yet.");
  }
}

/// Converter used to convert a [XmlAttribute] to a [TemplateAttribute]
class PageNodeAttributeConverter extends TemplateAttributeConverter<XmlAttribute> {
  static const String namespace = "modularity.core.template.PageNodeAttributeConverter";
  final Logger logger;

  /// Initializes the converter
  PageNodeAttributeConverter({this.logger});

  /// Converts a [XMLAttribute] to a [TemplateAttribute]
  TemplateAttribute convert(XmlAttribute value) {
    TemplateAttribute attribute;

    switch(value.name.local) {
      case WidthAttribute.xmlName:
        attribute = new WidthAttribute.fromXmlAttribute(value, logger:logger);
        break;

      case HeightAttribute.xmlName:
        attribute = new HeightAttribute.fromXmlAttribute(value, logger:logger);
        break;

      case WeightAttribute.xmlName:
        attribute = new WeightAttribute.fromXmlAttribute(value, logger:logger);
        break;

      default:
        if(logger != null) {
          logger.log(new UnsupportedAttributeWarning(namespace, value.name.local));
        }
        break;
    }

    return attribute;
  }

  /// This method isn't implemented yet. It throws an exception
  XmlAttribute convertBack(TemplateAttribute value) {
    throw new UnimplementedError("Converting back to a XML attribute isn't supported yet.");
  }
}

/// Converter used to convert a [Template] to HTML
class HtmlTemplateConverter extends TemplateConverter<html.HtmlElement> {

  html.HtmlElement convert(Template template) {
    return _convert(template.node as PageNode);
  }

  html.HtmlElement _convert(PageNode templateNode) {
    var node = new html.DivElement();

    var contentOrientation = templateNode.parent is HorizontalNode ? Orientation.HORIZONTAL : Orientation.VERTICAL;
    var contentWeight = templateNode.parent is PageNode ? (templateNode.parent as PageNode).contentWeight : null;
    var weight = templateNode.weight;
    var height = templateNode.height;
    var width = templateNode.width;

    node.classes.add(templateNode.name);

    //set size
    if(weight != null || contentWeight != null) {
      _applyWeight(node, contentOrientation, contentWeight, weight);
    } else {
      _applySize(node, width, height);
    }

    for(var child in templateNode.children) {
      node.children.add(_convert(child));
    }

    return node;
  }

  _applyWeight(html.DivElement element, Orientation contentOrientation, int contentWeight, int weight) {
    contentWeight = contentWeight != null ? contentWeight : WeightAttribute.defaultWeight;
    weight = weight != null ? weight : 0;

    var size = WeightAttribute.defaultWeight * weight / contentWeight;

    switch(contentOrientation) {
      case Orientation.HORIZONTAL:
        element.style.width = "${size}%";
        break;

      default:
        element.style.height = "${size}%";
        break;
    }
  }

  _applySize(html.DivElement element, int width, int height) {
    if(width != null) {
      element.style.width = "${width}px";   //TODO allow % and px?
    }

    if(height != null) {
      element.style.height = "${height}px";
    }
  }

  Template convertBack(html.HtmlElement element) {
    throw new UnimplementedError("Converting back to a template isn't supported yet.");
  }

}


/// enums

class Orientation {
  final String _value;

  const Orientation._internal(this._value);

  factory Orientation.fromValue(String value) => value == HORIZONTAL.value ? HORIZONTAL : VERTICAL;

  toString() => 'Enum.$_value';

  String get value => _value;

  static const VERTICAL = const Orientation._internal("vertical");
  static const HORIZONTAL = const Orientation._internal("horizontal");
}


/// attributes

/// Representation of a width attribute
class WidthAttribute extends IntegerAttribute {
  static const String xmlName = "width";

  WidthAttribute({Logger logger}) : super(xmlName, logger: logger);

  WidthAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
  super.fromXmlAttribute(attribute, logger:logger);
}

/// Representation of a height attribute
class HeightAttribute extends IntegerAttribute {
  static const String xmlName = "height";

  HeightAttribute({Logger logger}) : super(xmlName, logger: logger);

  HeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
  super.fromXmlAttribute(attribute, logger:logger);
}

/// Representation of a weight attribute
class WeightAttribute extends IntegerAttribute {
  static const String xmlName = "weight";
  static const int defaultWeight = 100;

  WeightAttribute({Logger logger}) : super(xmlName, logger: logger);

  WeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
  super.fromXmlAttribute(attribute, logger:logger);
}


/// nodes

class PageNode extends TemplateNode {

  PageNode(XmlElement element, TemplateNode parent, {Logger logger}) :
  super(element, parent: parent, logger: logger);

  TemplateAttributeConverter get attributeConverter => new PageNodeAttributeConverter(logger: logger);

  /// Gets the weight of the node or `null` if not set
  int get weight => getAttributeValue(WeightAttribute.xmlName);

  /// Gets the height of the node or `null` if not set
  int get height => getAttributeValue(HeightAttribute.xmlName);

  /// Gets the width of the node or `null` if not set
  int get width => getAttributeValue(WidthAttribute.xmlName);

  /// Gets the weight sum of each node child or `null` if no child has a weight
  int get contentWeight {
    int weightSum = null;

    for(var child in children) {
      if(child is PageNode) {
        var childWeight = (child as PageNode).weight;

        if(childWeight != null) {
          weightSum = weightSum == null ? childWeight : weightSum += childWeight;
        }
      }
    }

    return weightSum;
  }
}

class OrientationNode extends PageNode {
  Orientation _orientation;

  OrientationNode(XmlElement element, TemplateNode parent, {Logger logger}) :
  super(element, parent, logger: logger) {
    _orientation = new Orientation.fromValue(element.name.local);
  }

  TemplateAttributeConverter get attributeConverter => new PageNodeAttributeConverter(logger: logger);

  Orientation get orientation => _orientation;
}

class HorizontalNode extends OrientationNode {
  static const xmlName = "horizontal";

  HorizontalNode(XmlElement element, TemplateNode parent, {Logger logger}) :
  super(element, parent, logger: logger);
}

class VerticalNode extends OrientationNode {
  static const xmlName = "vertical";

  VerticalNode(XmlElement element, TemplateNode parent, {Logger logger}) :
  super(element, parent, logger: logger);
}