part of modularity.core.template;

abstract class Binding<TElement extends html.Element, TProperty> {
  Property<TProperty> property;
  TElement element;

  Binding(this.element, this.property);

  /**
   * This function is invoked whenever the
   * value of the property is changed. So
   * the DOM element could be updated.
   */
  void notifyPropertyChanged();

  /**
   * Handler which is invoked before the binding
   * will be destroyed. This function should be used
   * to remove events from the DOM element.
   */
  void onUnbind();

  /**
   * Destroys the binding. This function
   * is used to avoid memory leaks.
   */
  void unbind() {
    onUnbind();
    element = null;
    property = null;
  }
}

abstract class TwoWayBinding<TElement extends html.Element, TProperty> extends Binding<TElement, TProperty> {

  TwoWayBinding(element, property) : super(element, property);

  /**
   * This function is invoked whenever the
   * value of the element is changed. So
   * the property could be updated.
   */
  void notifyElementChanged();
}

/**
 * One-way binding for divs
 */
class DivBinding<T> extends Binding<html.DivElement, T> {
  DivBinding(element, property) : super(element, property);

  void notifyPropertyChanged() {
    element.innerHtml = property.value;
  }
}

/**
 * Two-way binding for input fields
 */
class InputBinding<T> extends TwoWayBinding<html.InputElement, T> {
  StreamSubscription _subscription; //TODO add generic type

  InputBinding(element, property) : super(element, property) {
    _subscription = element.onChange.listen((event) {
       notifyElementChanged();
    });
  }

  void notifyPropertyChanged() {
    element.value = property.value;
  }

  void notifyElementChanged() {
    property.notifyElementChanged(element.value);
  }

  void onUnbind() {
    //remove event listener
    if(_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

}
