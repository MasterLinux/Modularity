part of modularity.core.template;

/// Converter used to convert a [JsonTemplate] to HTML
class JsonTemplateToHtmlConverter extends TemplateConverter<html.HtmlElement> {
  final String id;

  /// Initializes the converter. The [id] will be
  /// the ID of the created HTML element
  JsonTemplateToHtmlConverter(this.id);

  html.HtmlElement _convert(JsonTemplateNode value) {
    var node = new html.Element.tag(value.name);
    node.id = id;

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


class HtmlTemplate extends JsonTemplate { //TODO rename to HtmlTemplate
  html.HtmlElement _templateNode;

  /// Initializes the [PageTemplate] with the help of
  /// a JSON [template] string
  HtmlTemplate(String id, String template, {Logger logger}) :
    super(template, logger: logger) {
    _templateNode = new JsonTemplateToHtmlConverter(id).convert(this);
  }

  void render(String parentId) {
    var parent = html.document.getElementById(parentId);

    if(parent != null) {
      parent.nodes.add(_templateNode);
    } else if(logger != null) {
      //TODO log error
    }
  }

  void destroy() {
    _templateNode.remove();
  }
}
