library modularity.template;

import 'dart:html';
import 'dart:async';

import 'exception/exception.dart';

part 'element_type.dart';
part 'binding.dart';
part 'property.dart';

//https://groups.google.com/a/dartlang.org/forum/#!topic/web-ui/OEPXc8KtpVE
class Template {
  final String template;

  Template.from(this.template) {
    var n = _parse(template);
  }

  void _parse(String template) {
    var node = new Element.html(
        template,
        validator: new NodeValidatorBuilder()
          ..allowHtml5()
    );


    return node;
  }
}
   /*
class ModularityValidator extends NodeValidator {

  /*
  factory ModularityValidator({UriPolicy uriPolicy}) =>
    new _Html5NodeValidator(uriPolicy: uriPolicy);
    */
  bool allowsAttribute(Element element, String attributeName, String value) {
    return attributeName.startsWith('mod-');;
  }


  bool allowsElement(Element element) {
    return element.tagName.startsWith('MOD-');
  }


/*
  // Allow all elements which begin with ‘NG-’.
  bool allowsElement(Element element) =>
  element.tagName.startsWith('NG-');
  // Allow all attributes beginning with ‘NG-’, regardless of element
  // tag.
  bool allowsAttribute(
      Element element, String attributeName, String value) =>
  attributeName.startsWith('ng-');
  */

}
    */