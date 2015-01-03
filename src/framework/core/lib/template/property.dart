part of modularity.core.template;

typedef OnElementValueChangedHandler(Property sender);

class Property<T> {
  static const String namespace = "modularity.core.template.Property";
  OnElementValueChangedHandler _elValueChangedHandler;
  final Logger logger;
  Binding _binding;
  T _value;

  /**
   * Initializes the property
   */
  Property({this.logger});

  /**
   * Initializes the property
   * with an initial [value]
   */
  Property.withValue(T value, {this.logger}): _value = value;

  /**
   * Sets the value and updates
   * the DOM element bind to this
   * property. Throws an [MissingBindingException]
   * if [element] is not set.
   */
  set value(T val) {
    if(val != _value) {
      _value = val;
      notifyPropertyChanged();
    }
  }

  /**
   * Gets the value od this property
   */
  T get value {
    return _value;
  }

  /**
   * Binds a DOM element to
   * this property. It throws
   * an [NotSupportedElementException]
   * if there is no specific [Binding]
   * for the given [element]
   */
  Property<T> bind(html.Element element) {
    unbind();

    if(element is html.DivElement) { //TODO test
      _binding = new DivBinding(element, this);

    } else if(element is html.InputElement) {
      _binding = new InputBinding(element, this);

    } else if(logger != null) {
      logger.log(new UnsupportedElementError(namespace, element.tagName));
    }

    return this;
  }

  /**
   * Removes the binding. This function
   * should be called before removing
   * the bound DOM element from DOM.
   */
  Property<T> unbind() {
    if(_binding != null) {
      _binding.unbind();
      _binding = null;
    }

    return this;
  }

  /**
   * Notifies the DOM element that the value
   * is changed.
   */
  void notifyPropertyChanged() {
    if(_binding != null) {
      _binding.notifyPropertyChanged();
    } else if(logger != null) {
      logger.log(new MissingBindingError(namespace));
    }
  }

  /**
   * Sets the new [value] of the bound element
   * and invokes the [OnElementValueChangedHandler]
   * on change
   */
  void notifyElementValueChanged(T value) {
    if(value != _value) {
      _value = value;

      if(_elValueChangedHandler != null) {
        _elValueChangedHandler(this);
      }
    }
  }

  /**
   * Registers an event [handler] which is invoked
   * whenever the value of the DOM element is changed.
   * This happens in case of a two-way binding for example when
   * the user enters a new value into an input element.
   */
  Property<T> onElementValueChanged(OnElementValueChangedHandler handler) {
    _elValueChangedHandler = handler;
    return this;
  }
}

/// Error which is thrown whenever a binding is missing
class MissingBindingError extends ErrorMessage {

  MissingBindingError(namespace) : super(namespace);

  String get message =>  "The binding must not be null.";
}

/// Error which is thrown whenever a specific element type isn't supported yet
class UnsupportedElementError extends ErrorMessage {
  final String elementType;

  UnsupportedElementError(namespace, this.elementType) : super(namespace);

  String get message => "The element of type [$elementType] is currently not supported.";
}
