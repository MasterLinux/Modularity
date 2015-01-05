library modularity.core.template;

import 'package:quiver/core.dart' show hash2;
import 'package:xml/xml.dart';
import 'dart:html' as html;

import '../utility/converter.dart' show Converter;
import '../logger.dart' show Logger, ErrorMessage, WarningMessage;
import 'dart:convert' show JSON;
import 'dart:async' show StreamSubscription;

part 'json_template.dart';
part 'html_template.dart';
part 'binding.dart';
part 'property.dart';

abstract class TemplateController {
  //TODO implement
}

/// A template is an abstraction layer
/// between an input format like a XML document
/// and a specific output format like HTML
abstract class Template<TIn> {
  static const String namespace = "modularity.core.template.Template";

  final TemplateController controller;
  final List<TemplateBinding> bindings;
  final List<TemplateEvent> events;
  final Logger logger;
  final String id;

  html.HtmlElement _htmlNode;

  /// Initializes the template with a specific input format of type [TIn]
  Template(TIn template, this.id, this.controller, {this.logger}) :
    bindings = new List<TemplateBinding>(),
    events = new List<TemplateEvent>() {
    _htmlNode = buildHtmlNode(nodeConverter.convert(template), id);
  }

  /// Gets the [HtmlElement] of this template
  html.HtmlElement get node => _htmlNode;

  /// Gets the [TemplateNodeConverter] to convert the given input to a [TemplateNode]
  TemplateNodeConverter<TIn> get nodeConverter;

  /// Adds the template to the DOM
  void render(String parentId) {
    var parent = html.document.getElementById(parentId);

    if(parent != null) {
      parent.nodes.add(_htmlNode);
    } else if(logger != null) {
      logger.log(new UnknownParentNodeError(namespace, parentId));
    }
  }

  /// Removes the template from DOM
  void destroy() {
    _htmlNode.remove();
  }

  /// Builds the HTML template with the help of a [TemplateNode]
  html.HtmlElement buildHtmlNode(TemplateNode templateNode, [String id = null]) {
    var node = new html.Element.tag(templateNode.name);

    //TODO set bindings

    //set template id
    if(id != null) {
      node.id = id;
    }

    for (var attribute in templateNode.attributes) {
      node.attributes[attribute.name] = attribute.value;
    }

    for (var child in templateNode.children) {
      node.children.add(buildHtmlNode(child));
    }

    return node;
  }
}

/// Error which is used whenever the parent node isn't found
class UnknownParentNodeError extends ErrorMessage {
  final String parentId;

  UnknownParentNodeError(String namespace, this.parentId) : super(namespace);

  @override
  String get message => "Unable to find parent node with ID => \"$parentId\".";
}

/// Converter used to convert a specific input of type [TIn] to a [TemplateNode]
abstract class TemplateNodeConverter<TIn> extends Converter<TIn, TemplateNode> {}

/// Converter used to convert a specific input of type [TIn] to a [TemplateAttribute]
abstract class TemplateAttributeConverter<TIn> extends Converter<TIn, TemplateAttribute> {}

/// Converter used to convert a [Template] to another format of type [TOut]
abstract class TemplateConverter<TOut> extends Converter<Template, TOut> {}

/// Represents a node similar to a XML or HTML node.
abstract class TemplateNode<TIn> {
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
  TemplateNode(this.name, List<TIn> attributes, {this.parent, this.logger}) :
      this.attributes = new List<TemplateAttribute>(),
      this.children = new List<TemplateNode>() {
    _applyAttributes(attributes);
  }

  /// Gets the [TemplateAttributeConverter] used to convert a XML attribute to a [TemplateAttribute]
  TemplateAttributeConverter get attributeConverter;

  void _applyAttributes(List<TIn> attributes) {
    var converter = attributeConverter;

    if(converter != null) {
      for(var attribute in attributes) {
        this.attributes.add(converter.convert(attribute)); //TODO check whether attribute is already added
      }
    } else if(logger != null && attributes.length > 0) {
      //TODO show warning if converter is null but there are attributes
    }
  }

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
/// It is used to parse TIn attributes
/// to its final representation, like a
/// CSS class, etc.
abstract class TemplateAttribute<TValue> {
  final Logger logger;

  /// Gets the name of the attribute
  final String name;

  /// Gets or sets the value of the attribute
  TValue value;

  /// Initializes the template attribute with a [name] and its [value]
  TemplateAttribute(this.name, this.value, {this.logger});

  /// Compares this attribute with another one
  bool operator ==(TemplateAttribute another)
      => another.name == name && another.value == value;

  /// Gets the hash code of this attribute
  int get hashCode => hash2(name, value);
}

/// Warning which is used whenever an attribute isn't supported
class UnsupportedAttributeWarning extends WarningMessage {
  final String attributeName;

  UnsupportedAttributeWarning(String namespace, this.attributeName) : super(namespace);

  @override
  String get message =>
      "Attribute => \"$attributeName\" isn't supported by the current template type. You should remove all unsupported attributes for a better parsing performance";
}

/*
/// Represents an event usually used for
/// nodes, like a click or hover
class TemplateEvent {
  final List<TemplateBindingParameter> bindings;
  final String callbackName;

  TemplateEvent(this.callbackName) : bindings = new List<TemplateBindingParameter>();
}

///
class TemplateBindingParameter {
  final String name;
  final String value;

  TemplateBindingParameter(this.name, this.value);
}

class TemplateBinding {
  final String attributeName;
  final String propertyName;

  TemplateBinding(this.attributeName, this.propertyName);
}
*/