library modularity.template;

import 'dart:html' as html;
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
    var node = new html.Element.html(
        template,
        validator: new html.NodeValidatorBuilder()
          ..allowHtml5()
          ..add(new ModularityValidator())
    );


    return node;
  }
}

class ModularityValidator implements html.NodeValidator {

  bool allowsAttribute(html.Element element, String attributeName, String value) {
    return attributeName.startsWith('mod-'); //TODO find nicely attribute name
  }

  bool allowsElement(html.Element element) {
    return true;
  }
}
