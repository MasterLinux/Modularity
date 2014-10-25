library modularity.core.template;

import 'package:xml/xml.dart';
import 'dart:html' as html;
import 'dart:async';

import 'exception/exception.dart';
import '../logger.dart' show Logger;

part 'element_type.dart';
part 'binding.dart';
part 'property.dart';

//https://groups.google.com/a/dartlang.org/forum/#!topic/web-ui/OEPXc8KtpVE
abstract class Template {
  TemplateNode _template;
  final Logger logger;

  Template(String xmlTemplate, {this.logger}) {
    _template = convert(parse(xmlTemplate));
  }

  TemplateNode get template => _template;

  TemplateNode convert(XmlDocument document);

  html.HtmlElement toHtml() => _template.toHtml();
}

class PageTemplate extends Template {

  PageTemplate(String xmlTemplate, {Logger logger}) : super(xmlTemplate, logger: logger);

  TemplateNode convert(XmlDocument document) {
    return _parse(document.rootElement);
  }

  TemplateNode _parse(XmlElement xmlElement, [TemplateNode parent = null]) {
    TemplateNode node = new TemplateNode(xmlElement, parent, logger: logger);

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

//TODO Template node as abstract class and this one as impl -> PageTemplateNode
class TemplateNode {
  static XmlName _widthAttribute = new XmlName.fromString("width");
  static XmlName _heightAttribute = new XmlName.fromString("height");
  static XmlName _weightAttribute = new XmlName.fromString("weight");
  static const int _defaultSize = -1;
  Orientation _orientation;
  String _type;
  int _childrenWeight = 0;
  int _weight = _defaultSize;
  int _height = _defaultSize;
  int _width = _defaultSize;

  final Logger logger;

  final List<TemplateNode> children;

  /// Gets the parent node or `null` if there is no parent
  final TemplateNode parent;

  TemplateNode(XmlElement element, this.parent, {this.logger: null}) :
    this.children = new List<TemplateNode>() {

    _applyAttributes(element.attributes);
    _applyElementType(element.name);
    _applyOrientation(element.name);
  }

  /// Gets the orientation of the content
  Orientation get orientation => _orientation;

  /// Gets the type of this node
  String get type => _type;

  int get width => _width;

  int get height => _height;

  int get weight => _weight;

  int get childrenWeight => _childrenWeight;

  /// Gets the HTML representation of this node
  html.HtmlElement toHtml() {
    var node = new html.DivElement();

    node.classes
        ..add(type)
        ..add(orientation.value);

    _applySize(node);

    for(var child in children) {
      node.children.add(child.toHtml());
    }

    return node;
  }

  _applyOrientation(XmlName name) =>
      _orientation = new Orientation.fromValue(name.local);

  _applyElementType(XmlName name) =>
      _type = name.local;

  //TODO implement abstract Converter class and implement each apply method as Converter
  _applyAttributes(List<XmlAttribute> attributes) {
    for(var attribute in attributes) {
      if(attribute.name == _widthAttribute) {
        _width = _getAttributeValue(attribute);

      } else if(attribute.name == _heightAttribute) {
        _height = _getAttributeValue(attribute);

      } else if(attribute.name == _weightAttribute) {
        _weight = _getAttributeValue(attribute);

        if(parent != null) {
          parent._childrenWeight += _weight;
        }
      }
    }
  }

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
    else if(parent.orientation == Orientation.HORIZONTAL) {
      element.style.width = "${weight}%";
    }

    //is inside a parent with a vertical orientation
    else {
      element.style.height = "${weight}%";
    }
  }

  int _getAttributeValue(XmlAttribute attribute, {int defaultValue: _defaultSize}) {
    return int.parse(attribute.value, onError: (_){
      if(logger != null) {
        //TODO log invalid width value warning
      }

      return defaultValue;
    });
  }
}
