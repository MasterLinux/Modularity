part of modularity.template;

typedef OnElementValueChangedHandler(Property sender);

class Property<T> {
  OnElementValueChangedHandler _elValueChangedHandler;
  Binding _binding;
  T _value;

  /**
   * Initializes the property
   */
  Property();

  /**
   * Initializes the property
   * with an initial [value]
   */
  Property.withValue(T value) {
    _value = value;
  }

  operator <<(T value) { //TODO which operator could be used?
    this.value = value;
  }

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
  Property<T> bind(Element element) {
    ElementType type = new ElementType(element.tagName);
    unbind();

    switch(type) {
      case ElementType.DIV:
        _binding = new DivBinding(element, this);
        break;
      case ElementType.INPUT:
        _binding = new InputBinding(element, this);
        break;
      default:
        throw new NotSupportedElementException(element.tagName);
        break;
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
    } else {
      throw new MissingBindingException();
    }
  }

  /**
   * Sets the new [value] of the bound element
   * and invokes the [OnElementValueChangedHandler]
   * on change
   */
  void notifyElementChanged(T value) {
    if(value != _value) {
      _value = value;

      if(_elValueChangedHandler) {
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
  Property<T> listen(OnElementValueChangedHandler handler) {
    _elValueChangedHandler = handler;
    return this;
  }
}
