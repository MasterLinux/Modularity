library modularity.core.template;

import 'package:quiver/core.dart' show hash2;
import 'package:xml/xml.dart';
import 'dart:html' as html;

import '../utility/converter.dart' show Converter;
import '../logger.dart' show Logger, ErrorMessage, WarningMessage;

part 'page_template.dart';

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

/// Represents a node similar to a XML or HTML node.
abstract class TemplateNode {
  final Logger logger;

  /// Gets the name of this node
  final String name;

  /// A list of this node's children
  final List<TemplateNode> children;

  /// A list of this node's attributes
  final List<TemplateAttribute> attributes;

  /// Gets the parent node or `null` if there is no parent
  final TemplateNode parent;

  /// Initializes the [TemplateNode] with the help of a [XmlElement]
  TemplateNode(this.name, {this.parent, this.logger}) :
      this.attributes = new List<TemplateAttribute>(),
      this.children = new List<TemplateNode>();

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
}

/// Base class of a [TemplateAttribute]
/// It is used to parse a XML attribute
/// to its final representation, like a
/// CSS class, etc.
abstract class TemplateAttribute<TValue> {
  final Logger logger;

  /// Gets the name of the attribute
  final String name;

  /// Gets or sets the value of the attribute
  TValue value;

  /// Initializes the template attribute with a [name]
  TemplateAttribute(this.name, {this.logger});

  /// Initializes the attribute with the help of a [XmlAttribute]
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

/// Warning which is used whenever an attribute isn't supported
class UnsupportedAttributeWarning extends WarningMessage {
  final String attributeName;

  UnsupportedAttributeWarning(String namespace, this.attributeName) : super(namespace);

  @override
  String get message =>
      "Attribute => \"$attributeName\" isn't supported by the current template type. You should remove all unsupported attributes for a better parsing performance";
}

