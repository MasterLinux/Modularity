//part of modularity.core;
library modularity.core;

import 'utility/utility.dart';
import 'utility/class_utility.dart' as classUtil;
import 'dart:mirrors';
import 'dart:html' as html;
import 'dart:async' show StreamSubscription;
import 'event_args/event_args.dart' show EventArgs;


enum ViewBindingType {
  EVENT_HANDLER,
  ATTRIBUTE
}

class ViewBinding {
  final ViewBindingType type;
  final String attributeName;
  final String propertyName;

  ViewBinding(this.type, this.attributeName, this.propertyName);
}

class ViewTemplate {
  final String parentId;
  View _rootView;

  ViewTemplate(this.parentId, View view) {
    _rootView = view;
  }

  ViewTemplate.fromJsonMap(this.parentId, Map jsonMap) {
    // TODO implement
  }

  View get rootView => _rootView;

  void render() {
    if(rootView != null) {
      rootView.addToDOM(parentId);
    }
  }

  void destroy() {
    if(rootView != null) {
      rootView.removeFromDOM();
    }
  }

  static View createView(String viewType, {String libraryName: "modularity.core", List<ViewBinding> bindings, ViewModel viewModel, List<View> subviews}) {
    var classMirror = classUtil.getClassMirror(libraryName, viewType);

    var instanceMirror = classMirror.newInstance(new Symbol(""), [], {
      new Symbol("viewModel"): viewModel,
      new Symbol("bindings"): bindings
    });

    return instanceMirror.reflectee as View;
  }
}

// similar to the state in react.js
abstract class ViewModel {
  List<View> _views = new List<View>();
  InstanceMirror _instanceMirror;

  ViewModel() {
    _instanceMirror = reflect(this);
  }

  void notifyPropertyChanged(String name, dynamic value) {
    for(var view in _views) {
      view.notifyPropertyChanged(name, value);
    }
  }

  void onAttributeChanged(String name, dynamic value) {}

  void subscribe(View view) {
    if(!_views.contains(view)) {
      _views.add(view);
    }
  }

  void unsubscribe(View view) {
    if(_views.contains(view)) {
      _views.remove(view);
    }
  }

  void invokeEventHandler(String name, View sender, EventArgs args) {
    _instanceMirror.invoke(new Symbol(name), [sender, args]);
  }

  bool containsAttribute(String name) {
    return true; //TODO
  }

  bool containsEventHandler(String name) {
    return true;
  }
}

abstract class View {
  final Map<String, String> _eventHandlerBindings = new Map<String, String>();
  final Map<String, String> _attributeBindings = new Map<String, String>();
  final Map<String, String> _propertyBindings = new Map<String, String>();
  final List<View> subviews = new List<View>();
  final ViewModel viewModel;
  String _id;

  View({this.viewModel, List<ViewBinding> bindings}) {
    _id = new UniqueId("mod_view").build();
    viewModel.subscribe(this);

    //map attributes to view model
    if(bindings != null) {
      for(var binding in bindings) {
        addBinding(binding);
      }
    }
  }

  String get id => _id;

  View render();

  html.HtmlElement toHtml() {
    return render().toHtml();
  }

  void addToDOM(String parentId) {
    var element = toHtml()..id = id;
    var parentNode = html.document.querySelector(parentId);

    if(parentNode != null) {
      parentNode.nodes.add(element);
    } else {
      // TODO log node with ID is missing error
    }
  }

  void removeFromDOM() {
    cleanup();

    var node = html.document.querySelector("#${id}");

    if(node != null) {
      node.remove();
    } else {
      // TODO log warning -> node already removed from DOM
    }
  }

  void cleanup() {
    viewModel.unsubscribe(this);

    for(var subview in subviews) {
      subview.cleanup();
    }
  }

  bool hasAttribute(String name) => _attributeBindings.containsKey(name);

  bool hasEventHandler(String name) => _eventHandlerBindings.containsKey(name);

  void invokeEventHandler(String name, View sender, EventArgs args) {
    viewModel.invokeEventHandler(_eventHandlerBindings[name], sender, args);
  }

  void notifyPropertyChanged(String propertyName, dynamic value) {
    var attributeName = _propertyBindings.containsKey(propertyName) ? _propertyBindings[propertyName] : null;

    if(attributeName != null) {
      onAttributeChanged(attributeName, value);
    }
  }

  void onAttributeChanged(String name, dynamic value) {}

  void addBinding(ViewBinding binding) {
    if(viewModel != null) {
      switch(binding.type) {
        case ViewBindingType.ATTRIBUTE:
          _addAttributeBinding(binding.attributeName, binding.propertyName);
          break;
        case ViewBindingType.EVENT_HANDLER:
          _addEventHandlerBinding(binding.attributeName, binding.propertyName);
          break;
      }
    } else {
      // TODO log error viewModel is null
    }
  }

  void _addEventHandlerBinding(String attributeName, String propertyName) {
    if(viewModel.containsEventHandler(attributeName)) {
      if(!_eventHandlerBindings.containsKey(attributeName)) {
        _eventHandlerBindings[attributeName] = propertyName;
      } else {
        //TODO log error. binding already exists
      }
    } else {
      //TODO event handler is missing
    }
  }

  void _addAttributeBinding(String attributeName, String propertyName) {
    if(viewModel.containsAttribute(attributeName)) {
      if(!_attributeBindings.containsKey(attributeName) && !_propertyBindings.containsKey(propertyName)) {
        _attributeBindings[attributeName] = propertyName;
        _propertyBindings[propertyName] = attributeName;
      } else {
        //TODO log error. binding already exists
      }
    } else {
      //TODO attribute is missing
    }
  }
}

abstract class HtmlElementView<TElement extends html.HtmlElement> extends View {
  TElement _htmlElement;

  HtmlElementView({ViewModel viewModel, List<ViewBinding> bindings, TElement htmlElement}) :
    super(viewModel: viewModel, bindings: bindings) {
    _htmlElement = htmlElement;
    setup(_htmlElement);
  }

  TElement toHtml() => _htmlElement;

  View render() {
    return this;
  }

  void setup(TElement element);
}

class TextChangedEventArgs implements EventArgs {
  String text;

  TextChangedEventArgs(this.text);
}

///
///
class TextInput extends HtmlElementView<html.InputElement> {
  StreamSubscription<html.Event> _onTextChangedSubscription;

  // events
  static const String onTextChangedEvent = "onTextChanged";

  // attributes
  static const String textAttribute = "text";

  TextInput({ViewModel viewModel, List<ViewBinding> bindings}) :
    super(viewModel: viewModel, bindings: bindings, htmlElement: new html.InputElement());

  void setup(html.InputElement element) {
    if(hasEventHandler(onTextChangedEvent)) {
      _onTextChangedSubscription = element.onInput.listen((event) {
        invokeEventHandler(onTextChangedEvent, this, new TextChangedEventArgs(event.target.value));
      });
    }
  }

  void cleanup() {
    super.cleanup();

    if(_onTextChangedSubscription != null) {
      _onTextChangedSubscription.cancel();
      _onTextChangedSubscription = null;
    }
  }

  void onAttributeChanged(String name, dynamic value) {
    switch(name) {
      case textAttribute:
        text = value as String;
        break;
    }
  }

  set text(String text) => _htmlElement.value = text;

  String get text => _htmlElement.value;
}

class TestView extends View { //TODO remove

  TestView({ViewModel viewModel, List<ViewBinding> bindings}) :
    super(viewModel: viewModel, bindings: bindings);

  View render() {
    return ViewTemplate.createView("TextInput", viewModel: viewModel, bindings: [
      new ViewBinding(ViewBindingType.EVENT_HANDLER, TextInput.onTextChangedEvent, "testFunc"),
      new ViewBinding(ViewBindingType.ATTRIBUTE, TextInput.textAttribute, "title")
    ]);
  }
}