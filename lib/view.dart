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
  final dynamic defaultValue;

  ViewBinding(this.type, this.attributeName, this.propertyName, {this.defaultValue});
}

class ViewTemplateParser {
  final ViewModel viewModel;

  static const String attributesKey = "attributes";
  static const String subviewsKey = "subviews";
  static const String eventsKey = "events";
  static const String libraryKey = "lib";
  static const String typeKey = "type";
  static const String nameKey = "name";
  static const String valueKey = "value";
  static const String bindingKey = "binding";

  ViewTemplateParser(this.viewModel);

  View parse(Map jsonMap) {
    return _parseView(jsonMap);
  }

  View _parseView(Map jsonMap) {
    var bindings = new List<ViewBinding>();
    var subviews = new List<View>();

    var libraryName = jsonMap[libraryKey] != null ? jsonMap[libraryKey] : View.defaultLibrary;
    var viewType = jsonMap[typeKey];

    var attributesList = jsonMap[attributesKey];
    if(attributesList != null && attributesList is List) {
      for(var attribute in attributesList) {
        bindings.add(_parseAttributeBinding(attribute));
      }
    }

    var eventsList = jsonMap[eventsKey];
    if(eventsList != null && eventsList is List) {
      for(var event in eventsList) {
        bindings.add(_parseEventHandlerBinding(event));
      }
    }

    var subviewsList = jsonMap[subviewsKey];
    if(subviewsList != null && subviewsList is List) {
      for(var subview in subviewsList) {
        subviews.add(_parseView(subview));
      }
    }

    return ViewTemplate.createView(
      viewType,
      libraryName: libraryName,
      viewModel: viewModel,
      bindings: bindings,
      subviews: subviews
    );
  }

  ViewBinding _parseEventHandlerBinding(Map event) {
    var eventHandlerName = event[nameKey];
    var propertyName = event[bindingKey];

    return new ViewBinding(ViewBindingType.EVENT_HANDLER, eventHandlerName, propertyName);
  }

  ViewBinding _parseAttributeBinding(Map attribute) {
    var attributeName = attribute[nameKey];
    var propertyName = attribute[bindingKey];
    var defaultValue = attribute[valueKey];

    return new ViewBinding(ViewBindingType.ATTRIBUTE, attributeName, propertyName, defaultValue: defaultValue);
  }
}

class ViewTemplate {
  final String parentId;
  View _rootView;

  ViewTemplate(this.parentId, View view) {
    _rootView = view;
  }

  ViewTemplate.fromJsonMap(this.parentId, Map jsonMap, {ViewModel viewModel}) {
    _rootView = new ViewTemplateParser(viewModel).parse(jsonMap);
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

  static View createView(String viewType, {String libraryName: View.defaultLibrary, List<ViewBinding> bindings, ViewModel viewModel, List<View> subviews}) {
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

  /// Initializes the view model
  ViewModel() {
    _instanceMirror = reflect(this);
  }

  /// Notifies the view that a specific property in this view model is changed
  /// Must be called to update the user interface
  ///
  /// Example:
  ///     // implement setter which notifies the view on update
  ///     set specificProperty(String val) {
  ///       _specificProperty = val;
  ///       notifyPropertyChanged("specificProperty");
  ///     }
  ///
  void notifyPropertyChanged(String name, dynamic value) {
    for(var view in _views) {
      view.notifyPropertyChanged(name, value);
    }
  }

  /// Handler which is invoked whenever a specific view attribute is changed
  /// This function can be overridden to handle attributes changes
  void onAttributeChanged(String name, dynamic value) {}

  /// Subscribes a view as observer so it is able to listen for attribute changes
  void subscribe(View view) {
    if(!_views.contains(view)) {
      _views.add(view);
    }
  }

  /// Unsubscribes a specific view from listening
  void unsubscribe(View view) {
    if(_views.contains(view)) {
      _views.remove(view);
    }
  }

  /// Helper function which is used to invoke a specific event handler in this view model
  void invokeEventHandler(String name, View sender, EventArgs args) {
    _instanceMirror.invoke(new Symbol(name), [sender, args]);
  }

  /// Checks whether this view model contains a specific property
  bool containsProperty(String name) {
    return true; //TODO
  }

  /// Checks whether this view model contains a specific event handler
  bool containsEventHandler(String name) {
    return true;
  }
}

/// Represents a view
abstract class View {
  final Map<String, String> _eventHandlerBindings = new Map<String, String>();
  final Map<String, String> _attributeBindings = new Map<String, String>();
  final Map<String, String> _propertyBindings = new Map<String, String>();
  static const String defaultLibrary = "modularity.core";
  final List<View> subviews = new List<View>();
  final ViewModel viewModel;
  String _id;

  /// Initializes the view with a [ViewModel] and a list of [ViewBinding]s
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

  /// Gets the ID of the view
  String get id => _id;

  /// TODO comment
  View render();

  /// Converts the view to an HTML element
  html.HtmlElement toHtml() {
    return render().toHtml();
  }

  /// Adds the view to DOM
  void addToDOM(String parentId) {
    var element = toHtml()..id = id;
    var parentNode = html.document.querySelector(parentId);

    if(parentNode != null) {
      parentNode.nodes.add(element);
    } else {
      // TODO log node with ID is missing error
    }
  }

  /// Removes the view from DOM
  void removeFromDOM() {
    cleanup();

    var node = html.document.querySelector("#${id}");

    if(node != null) {
      node.remove();
    } else {
      // TODO log warning -> node already removed from DOM
    }
  }

  /// Cleanup function which is used to remove events [StreamSubscription], etc.
  /// before the view is removed from DOM
  void cleanup() {
    viewModel.unsubscribe(this);

    for(var subview in subviews) {
      subview.cleanup();
    }
  }

  /// Checks whether a specific attribute binding exists
  bool hasAttribute(String name) => _attributeBindings.containsKey(name);

  /// Checks whether a specific event handler binding exists
  bool hasEventHandler(String name) => _eventHandlerBindings.containsKey(name);

  /// Invokes a specific event handler
  void invokeEventHandler(String name, View sender, EventArgs args) {
    viewModel.invokeEventHandler(_eventHandlerBindings[name], sender, args);
  }

  /// Notifies the view that a specific property in view model is changed
  void notifyPropertyChanged(String propertyName, dynamic value) {
    var attributeName = _propertyBindings.containsKey(propertyName) ? _propertyBindings[propertyName] : null;

    if(attributeName != null) {
      onAttributeChanged(attributeName, value);
    }
  }

  /// Handler which is invoked whenever a specific property in view model is changed
  void onAttributeChanged(String name, dynamic value) {}

  /// Adds a new view binding
  void addBinding(ViewBinding binding) { // TODO allow multiple bindings
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
    if(viewModel.containsProperty(propertyName)) {
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

/// A view implementation used to create views using a [HtmlElement]
abstract class HtmlElementView<TElement extends html.HtmlElement> extends View {
  TElement _htmlElement;

  /// Initializes the view
  HtmlElementView({ViewModel viewModel, List<ViewBinding> bindings, TElement htmlElement}) :
    super(viewModel: viewModel, bindings: bindings) {
    _htmlElement = htmlElement;
    setup(_htmlElement);
  }

  TElement toHtml() => _htmlElement;

  View render() {
    return this;
  }

  /// Function usually used to setup event handler
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