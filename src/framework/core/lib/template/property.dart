part of modularity.core.template;

typedef OnElementValueChangedHandler<TPropertyValue>(Property<TPropertyValue> sender);
typedef OnPropertyChangedHandler<TPropertyValue>(Property<TPropertyValue> sender);

class Property<TPropertyValue> {
  final List<OnElementValueChangedHandler<TPropertyValue>> elementValueChangedHandler;
  final List<OnPropertyChangedHandler<TPropertyValue>> propertyChangedHandler;
  TPropertyValue _value;

  /**
   * Initializes the property
   * with an initial [value]
   */
  Property.withValue(TPropertyValue value): _value = value;

  /**
   * Initializes the property
   */
  Property() :
    elementValueChangedHandler = new List<OnElementValueChangedHandler<TPropertyValue>>(),
    propertyChangedHandler = new List<OnPropertyChangedHandler<TPropertyValue>>();

  /**
   * Sets the value and notifies
   * each listener that the value
   * is changed
   */
  set value(TPropertyValue val) {
    if(val != _value) {
      _value = val;
      _notifyPropertyChanged();
    }
  }

  /**
   * Gets the value od this property
   */
  TPropertyValue get value {
    return _value;
  }

  /**
   * Notifies each registered listener for property changes
   * that the value is changed.
   */
  void _notifyPropertyChanged() {
    for(var handler in propertyChangedHandler) {
      handler(this);
    }
  }

  /**
   * Registers an event [handler] which is invoked
   * whenever the value of the property is changed
   */
  void registerPropertyChangedHandler(OnPropertyChangedHandler<TPropertyValue> handler) {
    propertyChangedHandler.add(handler);
  }

  /**
   * Removes a specific handler
   */
  void removePropertyChangedHandler(OnPropertyChangedHandler<TPropertyValue> handler) {
    propertyChangedHandler.remove(handler);
  }

  /**
   *
   */
  void notifyElementValueChanged(TPropertyValue value) {
    _value = value;

    for(var handler in elementValueChangedHandler) {
      handler(this);
    }
  }

  void registerElementValueChangedHandler(OnElementValueChangedHandler<TPropertyValue> handler) {
    elementValueChangedHandler.add(handler);
  }
}
