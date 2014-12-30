part of modularity.core.template;

/// Template used for page layouts.
///
/// #Template nodes
/// A [PageTemplate] template supports a small set of predefined [TemplateNode]s like the [HorizontalNode], etc.
/// In addition it allows the usage of custom nodes. These custom nodes must be handled by the app developer for
/// example by defining CSS classes. Each predefined [TemplateNode] has a lowercase name. A custom node should be
/// named in CamelCase like the example below.
///
/// ### horizontal
/// Used to arrange all children horizontal
///
/// ### vertical
/// Used to arrange all children vertical
///
/// #Example
///     var template = new PageTemplate(
///         '''
///         <?xml version="1.0"?>
///         <vertical height="20">
///           <Header />
///           <horizontal>
///             <Navigation weight="10" />
///             <Content />
///           </horizontal>
///         </vertical>
///         '''
///     );
///
class PageTemplate extends Template<XmlElement> {

  /// Initializes the [PageTemplate]
  PageTemplate(String xmlTemplate, {Logger logger}) :
      super(parse(xmlTemplate).rootElement, logger: logger);

  /// Gets the converter to convert a [XmlNode] to a [PageTemplateNode]
  TemplateNodeConverter get nodeConverter => new PageTemplateNodeConverter(logger:logger);
}

/// Default template for pages
class DefaultPageTemplate extends PageTemplate {
  static const _defaultTemplate =
      '''
        <?xml version="1.0"?>
        <vertical>
        </vertical>
      '''; //TODO load from file

  /// Initializes the [PageTemplate]
  DefaultPageTemplate({Logger logger}) :
      super(_defaultTemplate, logger: logger);
}

/// This node is similar to a XML or HTML node
/// and can contain [attributes] and node [children].
/// A template node is generated with the help of
/// a [XmlElement] and can be converted in any
/// format using a [TemplateNodeConverter].
abstract class PageTemplateNode extends TemplateNode {

  /// Initializes the [PageTemplateNode] with the help of a [XmlElement]
  PageTemplateNode(XmlElement element, {PageTemplateNode parent, Logger logger}) :
      super(element.name.local, parent: parent, logger: logger) {
    _applyAttributes(element.attributes);
  }

  _applyAttributes(List<XmlAttribute> xmlAttributes) {
    var converter = attributeConverter;

    if(converter != null) {
      for(var xmlAttribute in xmlAttributes) {
        var attribute = converter.convert(xmlAttribute);

        if(attribute != null) {
          attributes.add(attribute);
        }
      }
    } else if(logger != null && attributes.length > 0) {
      //TODO show warning if converter is null but there are attributes
    }
  }
}

/// Converter used to convert a [XmlElement] to a [TemplateNode]
class PageTemplateNodeConverter extends TemplateNodeConverter<XmlElement> {
  final Logger logger;

  /// Initializes the converter
  PageTemplateNodeConverter({this.logger});

  /// Converts a [XmlElement] to a [PageTemplateNode]
  PageTemplateNode convert(XmlElement value) {
    return _convert(value);
  }

  PageTemplateNode _convert(XmlElement xmlElement, {PageTemplateNode parent}) {
    var node = _createNode(xmlElement, parent);

    for(var child in xmlElement.children) {
      if(child.nodeType == XmlNodeType.ELEMENT) {
        node.children.add(_convert(child, parent: node));
      }
    }

    return node;
  }

  PageTemplateNode _createNode(XmlElement xmlElement, PageTemplateNode parent) {
    PageTemplateNode node;

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

  /// This method isn't implemented yet. It throws an [UnimplementedError]
  XmlElement convertBack(PageTemplateNode value) {
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

  /// This method isn't implemented yet. It throws an [UnimplementedError]
  XmlAttribute convertBack(TemplateAttribute value) {
    throw new UnimplementedError("Converting back to a XML attribute isn't supported yet.");
  }
}

/// Converter used to convert a [Template] to HTML
class HtmlTemplateConverter extends TemplateConverter<html.HtmlElement> {

  /// Converts a [Template] to HTML
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

  /// This method isn't implemented yet. It throws an [UnimplementedError]
  Template convertBack(html.HtmlElement element) {
    throw new UnimplementedError("Converting back to a template isn't supported yet.");
  }
}

/// Enum which represents a vertical or horizontal orientation
class Orientation {
  final String _value;

  const Orientation._internal(this._value);

  /// Creates an [Orientation] by its [value]. Whenever the [value] isn't valid it returns a [Orientation.VERTICAL] enum
  factory Orientation.fromValue(String value) => value == HORIZONTAL.value ? HORIZONTAL : VERTICAL;

  toString() => 'Enum.$_value';

  /// Gets the [String] representaion of the orientation
  String get value => _value;

  static const VERTICAL = const Orientation._internal("vertical");
  static const HORIZONTAL = const Orientation._internal("horizontal");
}

/// Represents the width of a node
class WidthAttribute extends IntegerAttribute {

  /// The XML name of the attribute
  static const String xmlName = "width";

  /// Creates a new [WidthAttribute]
  WidthAttribute({Logger logger}) : super(xmlName, logger: logger);

  /// Creates a [WidthAttribute] with the help of a [XmlAttribute]
  WidthAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}

/// Represents the height of a node
class HeightAttribute extends IntegerAttribute {

  /// The XML name of the attribute
  static const String xmlName = "height";

  /// Creates a new [HeightAttribute]
  HeightAttribute({Logger logger}) : super(xmlName, logger: logger);

  /// Creates a [HeightAttribute] with the help of a [XmlAttribute]
  HeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}

/// Representation of a weight.
///
/// #Example
///     var template = new PageTemplate(
///         '''
///         <?xml version="1.0"?>
///         <vertical> <!-- has a content weight of 3 -->
///           <Content weight="2" /> <!-- is twice as height as the Navigation node -->
///           <Navigation weight="1" />
///         </vertical>
///         '''
///     );
///
class WeightAttribute extends IntegerAttribute {

  /// The XML name of the attribute
  static const String xmlName = "weight";

  /// The default node width in percent
  static const int defaultWeight = 100;

  /// Creates a new [WeightAttribute]
  WeightAttribute({Logger logger}) : super(xmlName, logger: logger);

  /// Creates a [WeightAttribute] with the help of a [XmlAttribute]
  WeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}


/// nodes

class PageNode extends PageTemplateNode {

  PageNode(XmlElement element, PageTemplateNode parent, {Logger logger}) :
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

  OrientationNode(XmlElement element, PageTemplateNode parent, {Logger logger}) :
      super(element, parent, logger: logger) {
    _orientation = new Orientation.fromValue(element.name.local);
  }

  TemplateAttributeConverter get attributeConverter => new PageNodeAttributeConverter(logger: logger);

  Orientation get orientation => _orientation;
}

class HorizontalNode extends OrientationNode {
  static const xmlName = "horizontal";

  HorizontalNode(XmlElement element, PageTemplateNode parent, {Logger logger}) :
      super(element, parent, logger: logger);
}

class VerticalNode extends OrientationNode {
  static const xmlName = "vertical";

  VerticalNode(XmlElement element, PageTemplateNode parent, {Logger logger}) :
      super(element, parent, logger: logger);
}

/// Base class of a [PageTemplateAttribute]
/// It is used to parse a XML attribute
/// to its final representation, like a
/// CSS class, etc.
abstract class PageTemplateAttribute<TValue> extends TemplateAttribute<TValue> {

  /// Initializes the template attribute with a [name]
  PageTemplateAttribute(String name, {Logger logger}) : super(name, logger: logger);

  /// Initializes the attribute with the help of a [XmlAttribute]
  PageTemplateAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
  super(attribute.name.local, logger: logger) {
    value = _parseValue(attribute);
  }

  /// Get the value of the XML attribute
  TValue _parseValue(XmlAttribute attribute);
}

/// Attribute used for XML attributes with integer values
/// Tries to parse the value of the XML attribute to an integer,
/// whenever the parsing fails it falls back to `0`
///
///     <NodeName attributeName="42"></NodeName>
///
abstract class IntegerAttribute extends PageTemplateAttribute<int> {
  static const String namespace = "modularity.core.template.IntegerAttribute";

  /// Initializes the attribute with a [name]
  IntegerAttribute(String name, {Logger logger}) : super(name, logger: logger);

  /// Initializes the attribute with the help of a [XmlAttribute]
  IntegerAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
  super.fromXmlAttribute(attribute, logger:logger);

  int _parseValue(XmlAttribute attribute) {
    return int.parse(attribute.value, onError: (_){
      if(logger != null) {
        logger.log(new IntegerAttributeParsingError(namespace, name, attribute.name.local, attribute.value));
      }

      return 0;
    });
  }
}

/// Error which is used whenever a value of an attribute isn't valid
class IntegerAttributeParsingError extends ErrorMessage {
  final String nodeName;
  final String attributeName;
  final String attributeValue;

  IntegerAttributeParsingError(String namespace, this.nodeName, this.attributeName, this.attributeValue) : super(namespace);

  @override
  String get message =>
    "Unable to parse value of attribute => \"$nodeName.$attributeName\". An integer value is expected but was => \"$attributeValue\"";
}