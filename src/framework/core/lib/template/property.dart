part of modularity.template;

class Property<T> {
  Element _el;
  T _value;

  Property() {
  }

  Property.withValue(T val) {
    value = val;
  }

  operator <<(T val) { //TODO which operator could be used?
    value = val;
  }

  /**
   * Sets the value and updates
   * the DOM element bind to this
   * property
   */
  set value(T val) {
    _value = val;
    _notifyPropertyChanged();
  }

  /**
   * Gets the value od this property
   */
  T get value {
    return _value;
  }

  /**
   * Registers a DOM element
   */
  set element(Element el) {
    _el = el;

    //TODO check whether a two way binding or a one way binding is required
  }

  void _notifyPropertyChanged() {

  }
}
