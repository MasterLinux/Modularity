library modularity.core.template;

import 'package:xml/xml.dart' as xml;
import 'dart:html' as html;
import 'dart:async';

import 'exception/exception.dart';
import '../logger.dart' show Logger;

part 'element_type.dart';
part 'binding.dart';
part 'property.dart';

//https://groups.google.com/a/dartlang.org/forum/#!topic/web-ui/OEPXc8KtpVE
abstract class Template {
  html.Element _template;
  final Logger logger;

  Template(String xmlTemplate, {this.logger}) {
    _template = parse(xmlTemplate);
  }

  html.Element get template => _template;

  html.Element parse(String xmlTemplate) {
    var document = xml.parse(xmlTemplate);
    return convert(document);
  }

  html.Element convert(xml.XmlDocument document);
}

class PageTemplate extends Template {

  PageTemplate(String xmlTemplate, {Logger logger}) : super(xmlTemplate, logger: logger);

  html.Element convert(xml.XmlDocument document) {
    return _parse(document.rootElement);
  }

  TemplateNode _parse(xml.XmlElement xmlElement, [Orientation contentOrientation = null]) {
    TemplateNode node = new TemplateNode(xmlElement, contentOrientation, logger: logger);

    for(var child in xmlElement.children) {
      if(child.nodeType == xml.XmlNodeType.ELEMENT) {
        node.children.add(_parse(child, TemplateNode.getOrientation(node)));
      }
    }

    return node;
  }
}

class Orientation {
  final String _value;

  const Orientation._internal(this._value);

  toString() => 'Enum.$_value';

  String get value => _value;

  static const VERTICAL = const Orientation._internal("vertical");
  static const HORIZONTAL = const Orientation._internal("horizontal");

  static Orientation fromAttribute(String value) => value == HORIZONTAL.value ? HORIZONTAL : VERTICAL;
}

class TemplateNode extends html.HtmlElement {
  static xml.XmlName _widthAttribute = new xml.XmlName.fromString("width");
  static xml.XmlName _heightAttribute = new xml.XmlName.fromString("height");
  static xml.XmlName _weightAttribute = new xml.XmlName.fromString("weight");

  factory TemplateNode(xml.XmlElement xmlElement, Orientation contentOrientation, {Logger logger}) {
    var element = html.document.createElement("div");

    _applyAttributes(element, xmlElement.attributes, contentOrientation);
    _applyElementType(element, xmlElement.name);
    _applyOrientation(element, xmlElement.name);

    return element;
  }

  TemplateNode.created() : super.created();

  static Orientation getOrientation(html.HtmlElement element) =>
      element.classes.contains(Orientation.HORIZONTAL.value) ? Orientation.HORIZONTAL : Orientation.VERTICAL;

  static _applyOrientation(html.HtmlElement element, xml.XmlName elementName) =>
      element.classes.add(Orientation.fromAttribute(elementName.local).value);

  static _applyElementType(html.HtmlElement element, xml.XmlName elementName) =>
      element.classes.add(elementName.local);

  static _applyAttributes(html.HtmlElement element, List<xml.XmlAttribute> attributes, Orientation contentOrientation) {
    for(var attribute in attributes) {
      if(attribute.name == _widthAttribute) {
        _applyWidth(element, attribute);

      } else if(attribute.name == _heightAttribute) {
        _applyHeight(element, attribute);

      } else if(attribute.name == _weightAttribute) {
        _applyWeight(element, attribute, contentOrientation);
      }
    }
  }

  static _applyWidth(html.HtmlElement element, xml.XmlAttribute attribute) =>
      element.style.width = "${_getAttributeValue(attribute)}px";

  static _applyHeight(html.HtmlElement element, xml.XmlAttribute attribute) =>
      element.style.height = "${_getAttributeValue(attribute)}px";

  static _applyWeight(html.HtmlElement element, xml.XmlAttribute attribute, Orientation contentOrientation) {
    int weight = _getAttributeValue(attribute);

    //this is the root element
    if(contentOrientation == null) {
      element.style
        ..width = "${weight}%"
        ..height = "${weight}%";
    }

    //is inside a parent with a horizontal orientation
    else if(contentOrientation == Orientation.HORIZONTAL) {
      element.style.width = "${weight}%";
    }

    //is inside a parent with a vertical orientation
    else {
      element.style.height = "${weight}%";
    }
  }

  static int _getAttributeValue(xml.XmlAttribute attribute, {int defaultValue: 0}) {
    return int.parse(attribute.value, onError: (_){
      //if(_logger != null) {
      //TODO log invalid width value warning
      //}

      return defaultValue;
    });
  }
}
