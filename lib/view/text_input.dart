part of modularity.core.view;

class TextChangedEventArgs implements EventArgs {
  String text;

  TextChangedEventArgs(this.text);
}

///
///
class TextInput extends HtmlElementView<html.InputElement> {
  StreamSubscription<html.Event> _onTextChangedSubscription;

  TextInput({ViewModel viewModel, List<ViewBinding> bindings}) : super(viewModel: viewModel, bindings: bindings);

  // events
  static const String onTextChangedEvent = "onTextChanged";

  // attributes
  static const String textAttribute = "text";

  @override
  html.InputElement createHtmlElement() {
    return new html.InputElement();
  }

  @override
  void setupHtmlElement(html.InputElement element) {
    if (hasEventHandler(onTextChangedEvent)) {
      _onTextChangedSubscription = element.onInput.listen((event) {
        invokeEventHandler(onTextChangedEvent, this, new TextChangedEventArgs(event.target.value));
      });
    }
  }

  @override
  void cleanup() {
    super.cleanup();

    if (_onTextChangedSubscription != null) {
      _onTextChangedSubscription.cancel();
      _onTextChangedSubscription = null;
    }
  }

  @override
  void onAttributeChanged(String name, dynamic value) {
    switch (name) {
      case textAttribute:
        text = value as String;
        break;
    }
  }

  set text(String text) => _htmlElement.value = text;

  String get text => _htmlElement.value;
}

class ContentView extends HtmlElementView<html.DivElement> {

  @override
  html.DivElement createHtmlElement() => new html.DivElement();

  @override
  void setupHtmlElement(html.DivElement element) {
    // does nothing
  }
}


