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

  PageTemplate(String xmlTemplate, {Logger logger}) :
  super(parse(xmlTemplate).rootElement, logger: logger);

  TemplateNodeConverter get nodeConverter => new PageTemplateNodeConverter(logger:logger);
}

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

  /// This method isn't implemented yet. It throws an [UnimplementedError]
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