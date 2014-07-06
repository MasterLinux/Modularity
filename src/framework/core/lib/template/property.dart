part of modularity.template;

class Property<T> {
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
      _notifyPropertyChanged();
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
  set element(Element element) {
    //destroy previous binding
    if(_binding != null) {
      _binding.unbind();
      _binding = null;
    }

    switch(element.tagName.toLowerCase()) {
      case "div":
        _binding = new DivBinding(element, this);
        break;
      case "input":
        _binding = new InputBinding(element, this);
        break;
    }
  }

  void _notifyPropertyChanged() {
    if(_binding != null) {
      _binding.notifyPropertyChanged();
    } else {
      throw new MissingBindingException();
    }
  }
}
