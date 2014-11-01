library modularity.core.template;

import 'package:quiver/core.dart' show hash2;
import 'package:xml/xml.dart';
import 'dart:html' as html;
import 'dart:async';

import 'exception/exception.dart';
import '../logger.dart' show Logger, ErrorMessage, WarningMessage;

part 'page_template.dart';
part 'element_type.dart'; //TODO remove?
part 'binding.dart'; //TODO remove?
part 'property.dart'; //TODO remove?

//TODO move to utilities namespace
abstract class Converter<TIn, TOut> {
  TOut convert(TIn value);
  TIn convertBack(TOut value);
}

/// A template is an abstraction layer
/// between an input format like a XML document
/// and a specific output format like HTML
abstract class Template<TIn> {
  final Logger logger;
  TemplateNode _node;

  /// Initializes the template with a specific input format of type [TIn]
  Template(TIn template, {this.logger}) {
    _node = nodeConverter.convert(template);
  }

  /// Gets the [TemplateNode] of this template
  TemplateNode get node => _node;

  /// Gets the [TemplateNodeConverter] to convert the given input to a [TemplateNode]
  TemplateNodeConverter<TIn> get nodeConverter;
}

/// Converter used to convert a specific input of type [TIn] to a [TemplateNode]
abstract class TemplateNodeConverter<TIn> extends Converter<TIn, TemplateNode> {}

/// Converter used to convert a specific input of type [TIn] to a [TemplateAttribute]
abstract class TemplateAttributeConverter<TIn> extends Converter<TIn, TemplateAttribute> {}

/// Converter used to convert a [Template] to another format of type [TOut]
abstract class TemplateConverter<TOut> extends Converter<Template, TOut> {}

/// This node is similar to a XML or HTML node
/// and can contain [attributes] and node [children].
/// A template node is generated with the help of
/// a [XmlElement] and can be converted in any
/// format using a [TemplateNodeConverter].
abstract class TemplateNode {
  final Logger logger;

  /// Gets the name of this node
  final String name;

  ///
  final List<TemplateNode> children;

  final List<TemplateAttribute> attributes;

  /// Gets the parent node or `null` if there is no parent
  final TemplateNode parent;

  /// Initializes the [TemplateNode] with the help of a [XmlElement]
  TemplateNode(XmlElement element, {this.parent, this.logger}) :  //TODO use TIn instead of XmlElement and create a new XmlTemplateNode
      this.attributes = new List<TemplateAttribute>(),
      this.children = new List<TemplateNode>(),
      this.name = element.name.local {
    _applyAttributes(element.attributes);
  }

  /// Gets the [TemplateAttributeConverter] used to convert a XML attribute to a [TemplateAttribute]
  TemplateAttributeConverter get attributeConverter;

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

/// Base class of a [TemplateAttribute]
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

/// Attribute used for XML attributes with integer values
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

/// Warning which is used whenever an attribute isn't supported
class UnsupportedAttributeWarning extends WarningMessage {
  final String attributeName;

  UnsupportedAttributeWarning(String namespace, this.attributeName) : super(namespace);

  @override
  String get message =>
  "Attribute => \"$attributeName\" isn't supported by the current template type. You should remove all unsupported attributes for a better parsing performance";
}

