part of modularity.core.template;

/// Converter used to convert a [JsonTemplate] to HTML
class JsonTemplateToHtmlConverter extends TemplateConverter<html.HtmlElement> {

  html.HtmlElement _convert(JsonTemplateNode value) {
    var node = new html.Element.tag(value.name);

    for (var attribute in value.attributes) {
      node.attributes[attribute.name] = attribute.value;
    }

    for (var child in value.children) {
      node.children.add(_convert(child));
    }

    return node;
  }

  /// Converts a [JsonTemplate] to a [HtmlElement]
  html.HtmlElement convert(JsonTemplate value) {
    return _convert(value.node);
  }

  /// This method isn't implemented yet. It throws an [UnimplementedError]
  JsonTemplate convertBack(html.HtmlElement value) {
    throw new UnimplementedError("Converting back to a template isn't supported yet.");
  }

}
