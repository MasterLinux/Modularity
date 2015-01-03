#Data-Binding
There are two available bindings, a simple one-way and a two-way binding which are used to update the `DOM` and a `Property` automatically.

##Available properties
* Property<T>
> A simple property
* CollectionProperty<T extends Collection>
> A property for collections

##Supported HTML elements
* DivElement
* InputElement

###InputElement binding
An input element supports the two-way binding

```dart
Property<String> title = new Property<String>.withValue("initial title");
InputElement input = html.document.querySelector("#testInput");

// Binds the input to the title
title.bind(input);

// Event handler which is invoked whenever the element value is updated
title.onElementValueChanged((sender) {
   print(sender.value);
});

// Updates the input value
title.value = "new title";

// Removes the binding
title.unbind();
```