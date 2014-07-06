part of modularity.template;

abstract class Binding<TElement extends Element, TProperty> {
  final Property<TProperty> property;
  final TElement element;

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

abstract class TwoWayBinding<TElement extends Element, TProperty> extends Binding<TElement, TProperty> {

  TwoWayBinding(element, property) : super(this.element, this.property);

  /**
   * This function is invoked whenever the
   * value of the element is changed. So
   * the property could be updated.
   */
  void notifyElementChanged();
}

class DivBinding<T> extends Binding<DivElement, T> {
  DivBinding(element, property) : super(this.element, this.property);

  void notifyPropertyChanged() {
    element.innerHtml = property.value;
  }
}

class InputBinding<T> extends TwoWayBinding<InputElement, T> {
  StreamSubscription _subscription; //TODO add generic type

  InputBinding(element, property) : super(this.element, this.property) {
    _subscription = element.onChange.listen((event) {
       notifyElementChanged();
    });
  }

  void notifyPropertyChanged() {
    element.value = property.value;
  }

  void notifyElementChanged() {
    property._value = element.value;
  }

  void onUnbind() {
    //remove event listener
    _subscription.cancel();
  }


}
