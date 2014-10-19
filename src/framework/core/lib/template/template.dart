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
  static const String elementHorizontal = "horizontal";
  static const String elementVertical = "vertical";
  static const String cssClassPage = "page";
  static const String attributeWeight = "weight";
  static const String attributeHeight = "height";
  static const String attributeWidth = "width";

  PageTemplate(String xmlTemplate, {Logger logger}) : super(xmlTemplate, logger: logger);

  html.Element convert(xml.XmlDocument document) {
    var elementType = document.rootElement.name;

    html.Element template = new html.DivElement()
        ..classes.add(cssClassPage);

    if(elementType == new xml.XmlName.fromString(elementHorizontal) ||
        elementType == new xml.XmlName.fromString(elementVertical)) {
      template = _parseAttributes(document.rootElement, template);
      template.classes.add(elementType);

    } else if(logger != null) {
      //TODO log invalid root error
    }

    return template;
  }

  html.Element _parseAttributes(xml.XmlElement xmlElement, html.Element htmlElement) {
    for(var attribute in xmlElement.attributes) {
      if(attribute.name == new xml.XmlName.fromString(attributeWidth)) {
        int width = _parseAttributeValue(attribute);
        htmlElement.style.width = "${width}px";

      } else if(attribute.name == new xml.XmlName.fromString(attributeHeight)) {
        int height = _parseAttributeValue(attribute);
        htmlElement.style.height = "${height}px";

      } else if(attribute.name == new xml.XmlName.fromString(attributeWeight)) {
        int weight = _parseAttributeValue(attribute);

        //this is the root element
        if(xmlElement.parent == null) {
          htmlElement.style
            ..width = "${weight}%"
            ..height = "${weight}%";
        }

        //is inside a parent with a horizontal orientation
        else if(xmlElement == null) {//(xmlElement.parent as xml.XmlNamed).name == new xml.XmlName.fromString(elementHorizontal)) {  //TODO check whether this works as expected
          htmlElement.style.width = "${weight}%";
        }

        //is inside a parent with a vertical orientation
        else {
          htmlElement.style.height = "${weight}%";
        }
      }
    }

    return htmlElement;
  }

  int _parseAttributeValue(xml.XmlAttribute attribute, {int defaultValue: 0}) {
    return int.parse(attribute.value, onError: (_){
      if(logger != null) {
        //TODO log invalid width value warning
      }

      return defaultValue;
    });
  }


  //TODO calculate weight in relation with all children
  html.Element _parseWeightAttribute(html.Element element) {
    if(element.attributes.containsKey(attributeWeight)) {
      var weight = int.parse(element.attributes[attributeWeight], onError: (_){
        if(logger != null) {
          //TODO log invalid weight value warning
        }

        return 0;
      });

      //this is the root element
      if(element.parent == null) {
        element.style
          ..width = "${weight}%"
          ..height = "${weight}%";
      }

      //is inside a parent with a horizontal orientation
      else if(element.parent.classes.contains(elementHorizontal)) {
        element.style.width = "${weight}%";
      }

      //is inside a parent with a vertical orientation
      else {
        element.style.height = "${weight}%";
      }
    }

    return element;
  }
}
