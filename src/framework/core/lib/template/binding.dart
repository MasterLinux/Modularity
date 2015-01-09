part of modularity.core.template;

/// Binding for bidirectional communication. If the property is
/// updated the HTML element will be notified and updated.
/// Whenever the HTML element is updated the property will be updated.
abstract class DataBinding<TElement, TPropertyValue> {
  Property<TPropertyValue> _property;
  TElement element;

  /**
   * This function is invoked whenever the
   * value of the property is changed. So
   * the DOM element could be updated.
   */
  void notifyPropertyChanged(Property<TPropertyValue> property);

  /**
   * This function is invoked whenever an
   * attribute of the element is changed. So
   * the property could be updated.
   */
  void notifyElementChanged();

  /**
   * Binds a property to a specific DOM element
   */
  void set property(Property<TPropertyValue> property) {
    _property = property;

    if(_property != null) {
      _property.registerPropertyChangedHandler(notifyPropertyChanged);
    }
  }

  /**
   * Gets the property of the binding
   */
  Property<TPropertyValue> get property {
    return _property;
  }

  /**
   * Destroys the binding. This function
   * is used to avoid memory leaks.
   */
  void unbind() {
    element = null;

    if(_property != null) {
      _property.removePropertyChangedHandler(notifyPropertyChanged);
      _property = null;
    }
  }
}

/// Error which is thrown whenever a specific element type isn't supported yet
class UnsupportedElementWarning extends WarningMessage {
  final String elementType;

  UnsupportedElementWarning(namespace, this.elementType) : super(namespace);

  String get message => "The element of type [$elementType] is currently not supported.";
}

/// Proxy class for element bindings
class ElementBinding extends DataBinding<html.Element, String> {
  static const String namespace = "modularity.core.template.ElementBinding";
  final Logger logger;
  DataBinding _binding;

  ElementBinding(html.Element element, Property<String> property, {this.logger}) {
    _binding = _getBinding(element, property);
  }

  void notifyPropertyChanged(Property<String> property) {
    if(_binding != null) {
      _binding.notifyPropertyChanged(property);
    }
  }

  void notifyElementChanged() {
    if(_binding != null) {
      _binding.notifyElementChanged();
    }
  }

  void unbind() {
    if(_binding != null) {
      _binding.unbind();
    }

    super.unbind();
  }

  DataBinding _getBinding(html.Element element, Property<String> property) {
    var tagName = element.tagName.toLowerCase();
    DataBinding binding = null;

    switch (tagName) {
      case "div":
        binding = new DivBinding(element, property);
        break;

      case "input":
        binding = new InputBinding(element, property);
        break;

      default:
        if(logger != null) {
          logger.log(new UnsupportedElementWarning(namespace, tagName));
        }
        break;
    }

    return binding;
  }
}

/**
 * One-way binding for divs
 */
class DivBinding extends DataBinding<html.DivElement, String> {
  DivBinding(element, property) {
    this.property = property;
    this.element = element;
  }

  void notifyPropertyChanged(Property<String> property) {
    element.innerHtml = property.value;
  }

  void notifyElementChanged() {
    //does nothing
  }
}

/**
 * Two-way binding for input fields
 */
class InputBinding extends DataBinding<html.InputElement, String> {
  StreamSubscription _subscription;

  InputBinding(html.Element element, property) {
    this.property = property;
    this.element = element;

    _subscription = element.onChange.listen((event) {
      notifyElementChanged();
    });
  }

  void notifyPropertyChanged(Property<String> property) {
    element.value = property.value;
  }

  void notifyElementChanged() {
    property.notifyElementValueChanged(element.value);
  }

  void unbind() {
    //remove event listener
    if(_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    super.unbind();
  }
}
