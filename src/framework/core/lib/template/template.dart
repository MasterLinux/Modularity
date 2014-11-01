library modularity.core.template;

import 'package:quiver/core.dart' show hash2;
import 'package:xml/xml.dart';
import 'dart:html' as html;
import 'dart:async';

import 'exception/exception.dart';
import '../logger.dart' show Logger, ErrorMessage, WarningMessage;

part 'element_type.dart';
part 'binding.dart';
part 'property.dart';

abstract class Converter<TIn, TOut> {
  TOut convert(TIn value);
  TIn convertBack(TOut value);
}

abstract class TemplateNodeConverter<TIn> extends Converter<TIn, TemplateNode> {}

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
    //TODO throw exception
  }
}

abstract class TemplateAttributeConverter<TIn> extends Converter<TIn, TemplateAttribute> {}

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
    //TODO throw exception
  }
}

/// Converter used to convert a [Template] to another format
abstract class TemplateConverter<TOut> extends Converter<Template, TOut> {}

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
    //TODO throw exception
  }

}

/// Representation of a template
abstract class Template<TIn> {
  final Logger logger;
  TemplateNode _node;

  /// Initializes the template with a [xmlTemplate]
  Template(TIn template, {this.logger}) {
    _node = nodeConverter.convert(template);
  }

  /// Gets the [TemplateNode] of this template
  TemplateNode get node => _node;

  TemplateNodeConverter<TIn> get nodeConverter;
}

class PageTemplate extends Template<XmlElement> {

  PageTemplate(String xmlTemplate, {Logger logger}) :
      super(parse(xmlTemplate).rootElement, logger: logger);

  TemplateNodeConverter get nodeConverter => new PageTemplateNodeConverter(logger:logger);
}

class Orientation {
  final String _value;

  const Orientation._internal(this._value);

  factory Orientation.fromValue(String value) => value == HORIZONTAL.value ? HORIZONTAL : VERTICAL;

  toString() => 'Enum.$_value';

  String get value => _value;

  static const VERTICAL = const Orientation._internal("vertical");
  static const HORIZONTAL = const Orientation._internal("horizontal");
}



abstract class TemplateNode {
  final Logger logger;

  /// Gets the name of this node
  final String name;

  ///
  final List<TemplateNode> children;

  final List<TemplateAttribute> attributes;

  /// Gets the parent node or `null` if there is no parent
  final TemplateNode parent;

  TemplateNode(XmlElement element, {this.parent, this.logger}) :
      this.attributes = new List<TemplateAttribute>(),
      this.children = new List<TemplateNode>(),
      this.name = element.name.local {
    _applyAttributes(element.attributes);
  }

  TemplateAttributeConverter get attributeConverter;

  //TODO user [] operator?
  /// Gets the value of a specific attribute
  getAttributeValue(String attributeName, {defaultValue}) {
    var attribute = attributes.firstWhere(
            (attribute) => attribute.name == attributeName, orElse: () => null
    );

    if(attribute != null) {
      defaultValue = attribute.value;
    }

    return defaultValue;
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
    } else if(logger != null && attributes.length > 0){
      //TODO show warning if converter is null but there are attributes
    }
  }
}

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

//TODO rename
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



//TODO needs data-binding
/// 1) Register allowed attributes
/// 2) Read XML
/// 3) Set name
/// 4) Iterate trough attrs -> tplAttr.fromXmlAttr(xmlAttr);

//TODO orientation node

/*
_applySize(html.HtmlElement element) {
    var isSizeApplied = false;

    if(weight != _defaultSize) {
      _applyWeight(element);
      isSizeApplied = true;
    }

    if(!isSizeApplied && height != _defaultSize) {
      element.style.height = "${height}px";
    }

    if(!isSizeApplied && width != _defaultSize) {
      element.style.width = "${width}px";
    }
  }

  _applyWeight(html.HtmlElement element) {
    //this is the root element
    if(parent == null) {
      element.style
        ..width = "${weight}%"
        ..height = "${weight}%";
    }

    //is inside a parent with a horizontal orientation
    else if((parent as PageTemplateNode).orientation == Orientation.HORIZONTAL) {
      element.style.width = "${weight}%";
    }

    //is inside a parent with a vertical orientation
    else {
      element.style.height = "${weight}%";
    }
  }
 */

/// logger messages

/// Warning which is used whenever a value of an attribute isn't valid
class IntegerAttributeParsingError extends ErrorMessage {
  final String nodeName;
  final String attributeName;
  final String attributeValue;

  IntegerAttributeParsingError(String namespace, this.nodeName, this.attributeName, this.attributeValue) : super(namespace);

  @override
  String get message =>
      "Unable to parse value of attribute => \"$nodeName.$attributeName\". An integer value is expected but was => \"$attributeValue\"";
}

class UnsupportedAttributeWarning extends WarningMessage {
  final String attributeName;

  UnsupportedAttributeWarning(String namespace, this.attributeName) : super(namespace);

  @override
  String get message =>
      "Attribute => \"$attributeName\" isn't supported by the current template type. You should remove all unsupported attributes for a better parsing performance";
}


/// attributes

/// Base class of a template attribute
/// It is used to parse a XML attribute
/// to its final representation, like a
/// CSS class, etc.
abstract class TemplateAttribute<TValue> {
  final Logger logger;
  final String name;
  TValue value;

  TemplateAttribute(this.name, {this.logger});

  TemplateAttribute.fromXmlAttribute(XmlAttribute attribute, {this.logger}) :
      this.name = attribute.name.local {
      value = _parseValue(attribute);
  }

  /// Get the value of the XML attribute
  TValue _parseValue(XmlAttribute attribute);

  /// Compares this attribute with another one
  bool operator ==(TemplateAttribute another)
      => another.name == name && another.value == value;

  /// Gets the hash code of this attribute
  int get hashCode => hash2(name, value);
}

/// Attribute used for attributes with integer values
/// Tries to parse the value of the XML attribute to an integer,
/// whenever the parsing fails it falls back to `0`
///
///     <NodeName attributeName="42"></NodeName>
///
abstract class IntegerAttribute extends TemplateAttribute<int> {
  static const String namespace = "modularity.core.template.IntegerAttribute";

  IntegerAttribute(String name, {Logger logger}) : super(name, logger: logger);

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
