part of modularity.template;

class ElementType {
  static const UNKNOWN = const ElementType._(0);
  static const DIV = const ElementType._(1);
  static const INPUT = const ElementType._(2);

  static get values => [UNKNOWN, DIV, INPUT];

  final int value;

  const ElementType._(this.value);

  factory ElementType(String tag) {
    tag = tag != null ? tag : "";
    ElementType type = ElementType.UNKNOWN;

    switch(tag) {
      case "DIV":
        type = ElementType.DIV;
        break;

      case "INPUT":
        type = ElementType.INPUT;
        break;
    }

    return type;
  }
}
