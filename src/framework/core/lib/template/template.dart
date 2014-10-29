library modularity.core.template;

import 'package:quiver/core.dart' show hash2;
import 'package:xml/xml.dart';
import 'dart:html' as html;
import 'dart:async';

import 'exception/exception.dart';
import '../logger.dart' show Logger, ErrorMessage;

part 'element_type.dart';
part 'binding.dart';
part 'property.dart';

abstract class Converter<TIn, TOut> {
  TOut convert(TIn value);
  TIn convertBack(TOut value);
}

abstract class TemplateAttributeConverter<TIn> extends Converter<TIn, TemplateAttribute> {}

class PageTemplateAttributeConverter extends TemplateAttributeConverter<XmlAttribute> {
  static XmlName _widthAttributeName = new XmlName.fromString("width");
  static XmlName _heightAttributeName = new XmlName.fromString("height");
  static XmlName _weightAttributeName = new XmlName.fromString("weight");
  final Logger logger;

  PageTemplateAttributeConverter({this.logger});

  TemplateAttribute convert(XmlAttribute value) {
    TemplateAttribute attribute;

    if(value.name == _widthAttributeName) {
      attribute = new WidthAttribute.fromXmlAttribute(value, logger:logger);

    } else if(value.name == _heightAttributeName) {
      attribute = new WidthAttribute.fromXmlAttribute(value, logger:logger);

    } else if(value.name == _weightAttributeName) {
      attribute = new WidthAttribute.fromXmlAttribute(value, logger:logger);

    } else {
      //TODO log unknown attribute error
    }

    return attribute;
  }

  XmlAttribute convertBack(TemplateAttribute value) {
    //TODO throw exception
  }

}

abstract class TemplateConverter<TOut> extends Converter<Template, TOut> {}

class HtmlTemplateConverter extends TemplateConverter<html.HtmlElement> {

  html.HtmlElement convert(Template template) {
    var node = new html.DivElement();

    //TODO implement

    return node;
  }

  Template convertBack(html.HtmlElement element) {

  }

}

/// Represents a template
abstract class Template {
  final Logger logger;
  TemplateNode _node;

  /// Initializes the template with a [xmlTemplate]
  Template(String xmlTemplate, {this.logger}) {
    _node = convert(parse(xmlTemplate));
  }

  /// Gets the [TemplateNode] of this template
  TemplateNode get node => _node;

  /// Converts the [XMLDocument] to its [TemplateNode] representation
  TemplateNode convert(XmlDocument document);
}

class PageTemplate extends Template {

  PageTemplate(String xmlTemplate, {Logger logger}) : super(xmlTemplate, logger: logger);

  TemplateNode convert(XmlDocument document) {
    return _parse(document.rootElement);
  }

  TemplateNode _parse(XmlElement xmlElement, [TemplateNode parent = null]) {
    TemplateNode node = new PageTemplateNode(xmlElement, parent, logger: logger);

    for(var child in xmlElement.children) {
      if(child.nodeType == XmlNodeType.ELEMENT) {
        node.children.add(_parse(child, node));
      }
    }

    return node;
  }
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

  _applyAttributes(List<XmlAttribute> xmlAttributes) {
    var converter = attributeConverter;

    for(var xmlAttribute in xmlAttributes) {
      var attribute = converter.convert(xmlAttribute);

      if(attribute != null) {
        children.add(attribute);
      }
    }
  }
}

class PageTemplateNode extends TemplateNode {

  PageTemplateNode(XmlElement element, PageTemplateNode parent, {Logger logger}) :
      super(element, parent: parent, logger: logger);

  TemplateAttributeConverter get attributeConverter => new PageTemplateAttributeConverter(logger: logger);

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
class AttributeParsingError extends ErrorMessage {
  final String nodeType;
  final String attributeName;
  final String attributeValue;

  AttributeParsingError(String namespace, this.nodeType, this.attributeName, this.attributeValue) : super(namespace);

  @override
  String get message =>
      "Unable to parse value of attribute => \"$nodeType.$attributeName\". An integer value is expected but was => \"$attributeValue\"";
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
  static const String namespace = "modularity.core.template.TemplateNode";

  IntegerAttribute(String name, {Logger logger}) : super(name, logger: logger);

  IntegerAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);

  int _parseValue(XmlAttribute attribute) {
    return int.parse(attribute.value, onError: (_){
      if(logger != null) {
        logger.log(new AttributeParsingError(namespace, name, attribute.name.local, attribute.value));
      }

      return 0;
    });
  }
}

/// Representation of a width attribute
class WidthAttribute extends IntegerAttribute {
  WidthAttribute({Logger logger}) : super("width", logger: logger);

  WidthAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}

/// Representation of a height attribute
class HeightAttribute extends IntegerAttribute {
  HeightAttribute({Logger logger}) : super("height", logger: logger);

  HeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}

/// Representation of a weight attribute
class WeightAttribute extends IntegerAttribute {
  WeightAttribute({Logger logger}) : super("weight", logger: logger);

  WeightAttribute.fromXmlAttribute(XmlAttribute attribute, {Logger logger}) :
      super.fromXmlAttribute(attribute, logger:logger);
}
