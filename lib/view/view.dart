library modularity.core.view;

import '../utility/class_utility.dart' as classUtil;
import '../event_args/event_args.dart' show EventArgs;
import '../utility/utility.dart' show UniqueId;
import '../logger.dart' show Logger;
import '../manifest.dart' show ViewTemplateModel, ViewBindingModel;
import '../utility/converter.dart' show Converter;

import 'dart:html' as html;
import 'dart:async' show StreamSubscription;
import 'dart:mirrors' show InstanceMirror, reflect;

part 'text_input.dart';

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

class ViewConverter implements Converter<ViewTemplateModel, View> {
  final ViewModel viewModel;

  ViewConverter(this.viewModel);

  View convert(ViewTemplateModel value) {
    var bindings = new List<ViewBinding>();
    var subviews = new List<View>();

    if(value.subviews != null) {
      for(var subview in value.subviews) {
        subviews.add(convert(subview));
      }
    }

    if(value.attributes != null) {
      for(var attribute in value.attributes) {
        bindings.add(new ViewBinding(
            ViewBindingType.ATTRIBUTE,
            attribute.attributeName,
            attribute.propertyName,
            defaultValue: attribute.defaultValue
        ));
      }
    }

    if(value.events != null) {
      for(var event in value.events) {
        bindings.add(new ViewBinding(
            ViewBindingType.EVENT_HANDLER,
            event.attributeName,
            event.propertyName
        ));
      }
    }

    return ViewTemplate.createView(
        value.type,
        libraryName: value.lib != null ? value.lib : View.defaultLibrary,
        viewModel: viewModel,
        bindings: bindings,
        subviews: subviews
    );
  }

  ViewTemplateModel convertBack(View value) {
    throw new UnimplementedError();
  }
}

class ViewTemplate {
  View _rootView;

  ViewTemplate(View view, {Logger logger}) {
    _rootView = view;
  }

  ViewTemplate.fromModel(ViewTemplateModel model, {ViewModel viewModel, Logger logger}) {
    _rootView = new ViewConverter(viewModel).convert(model);
  }

  View get rootView => _rootView;

  void render(String parentId) {
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

  void updateProperty(String name, dynamic value) {
    _instanceMirror.setField(new Symbol("${name}"), value);
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
  final List<View> subviews = new List<View>();
  final ViewModel viewModel;
  String _id;

  static const String defaultLibrary = "modularity.core.view";

  /// Initializes the view with a [ViewModel] and a list of [ViewBinding]s
  View({this.viewModel, List<ViewBinding> bindings}) {
    _id = new UniqueId("mod_view").build();
    viewModel.subscribe(this);
    setup(bindings);
  }

  /// Setups the view. Can be overridden to add event handler, etc.
  void setup(List<ViewBinding> bindings) {
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
          _addAttributeBinding(binding.attributeName, binding.propertyName, binding.defaultValue);
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

  void _addAttributeBinding(String attributeName, String propertyName, dynamic defaultValue) {
    if(viewModel.containsProperty(propertyName)) {
      if(!_attributeBindings.containsKey(attributeName) && !_propertyBindings.containsKey(propertyName)) {
        _attributeBindings[attributeName] = propertyName;
        _propertyBindings[propertyName] = attributeName;

        if(defaultValue != null) {
          viewModel.updateProperty(propertyName, defaultValue);
          //onAttributeChanged(attributeName, defaultValue);
        }
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

  HtmlElementView({ViewModel viewModel, List<ViewBinding> bindings}) : super(viewModel: viewModel, bindings: bindings);

  @override
  TElement toHtml() => _htmlElement;

  /// Method used to create the HTML element
  /// which represents this view
  TElement createHtmlElement();

  /// Method used to setup the HTML element like adding event handler, etc.
  void setupHtmlElement(TElement element);

  @override
  View render() {
    return this;
  }

  @override
  void setup(List<ViewBinding> bindings) {
    _htmlElement = createHtmlElement();

    super.setup(bindings);
    setupHtmlElement(_htmlElement);
  }
}


class TestView extends View { //TODO remove

  TestView({ViewModel viewModel, List<ViewBinding> bindings}) :
    super(viewModel: viewModel, bindings: bindings);

  @override
  View render() {
    return ViewTemplate.createView("TextInput", viewModel: viewModel, bindings: [
      new ViewBinding(ViewBindingType.EVENT_HANDLER, TextInput.onTextChangedEvent, "testFunc"),
      new ViewBinding(ViewBindingType.ATTRIBUTE, TextInput.textAttribute, "title")
    ]);
  }
}