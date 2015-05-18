part of modularity.core;

class ModuleContext {
  InitEventArgs arguments;
  ViewModel viewModel;

}

abstract class Mod extends ViewModel {
  ClassLoader _instance;
  View _view;

  Mod() {
    _instance = new ClassLoader.fromInstance(this);

    _instance.load().then((_) {
      onInit();
    });
  }

  /// Gets the data context. Can be overridden
  /// to set a custom view model
  ViewModel get dataContext => this;

  /// Sets a new view
  void set view(View view) {
    // clean up previous view
    if(_view != null) {
      dataContext.unsubscribe(_view);
    }

    _view = view;

    dataContext.subscribe(_view);
  }

  View get view => _view;

  void onPropertyChanged(String name) {
    if(dataContext != null) {
      var getter = _instance.getter[new Symbol(name)];

      if(getter != null) {
        dataContext.notifyPropertyChanged(name, getter.get());
      } else {
        // TODO throw warning
      }
    } else {
      // TODO throw warning
    }
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add(NavigationEventArgs args) {
    onBeforeAdd(args);
    _view.addToDOM(fragment.id); //TODO
    onAdded(args);
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove() {
    onBeforeRemove();
    _view.removeFromDOM();
    onRemoved();
  }

  /**
   * This init function is called once when the module
   * is initialized. This function is called once on app start.
   */
  void onInit();

  /**
   * This event handler is invoked when the module will be created,
   * but before the template of the module is added to the DOM.
   */
  void onBeforeAdd(NavigationEventArgs args);

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded(NavigationEventArgs args);

  /**
   * This event handler is invoked when the module
   * will be destroyed but before the template
   * is removed from DOM.
   */
  void onBeforeRemove();

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved();

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args);

  /**
   * This event handler is invoked whenever the loading state is
   * changed. For example if the module starts to load
   * data or receives data.
   */
  void onLoadingStateChanged(LoadingStateChangedEventArgs args);
}

/**
 * Helper class to load and handle annotated
 * modules. This class is used to load
 * modules with the help of its library
 * and class name.
 */
class Module { // TODO rename to ModuleDecorator?
  final Map<String, dynamic> attributes;
  final ViewTemplateModel viewTemplateModel;
  final ApplicationContext context;
  final Fragment fragment;
  final String libraryName;
  final String name;

  Field _dataContextField;
  ViewTemplate _template;
  ClassLoader _instance;

  annotations.ApplicationModule _meta;

  ViewTemplate get template => _template;
  utility.Logger get logger => context.logger;

  /**
   * Gets the meta information
   * of this module.
   */
  annotations.ApplicationModule get meta {
    return _meta;
  }

  /// Gets the dataContext
  ViewModel get dataContext => _dataContextField != null ? _dataContextField.get() : null;

  /**
   * Initializes the module with the help
   * of a class which uses module annotations.
   */
  Module(this.libraryName, this.name, this.viewTemplateModel, this.attributes, this.fragment, this.context) {
    _instance = new ClassLoader(new Symbol(libraryName), new Symbol(name), const Symbol(''), [context, new InitEventArgs(attributes)]);

    _instance.load().then((_) {
      onInit();
    });
  }

  /**
   * Adds the template of the module to DOM.
   */
  void add(NavigationEventArgs args) {
    onBeforeAdd(args);
    template.render(fragment.id);
    onAdded(args);
  }

  /**
   * Removes the template of the module from DOM.
   */
  void remove() {
    onBeforeRemove();
    template.destroy();
    onRemoved();
  }

  /**
   * This init function is called once when the module
   * is initialized on app start.
   */
  void onInit() {
    var annotation = _instance.metadata[#ApplicationModule];

    //get module information for registration
    if(annotation != null) {
      _meta = annotation as annotations.ApplicationModule;
      _dataContextField = _instance.fields.firstWhereMetadata((name, meta) => name == #DataContextAnnotation, orElse: () => null);
      _template = template != null ? new ViewTemplate.fromModel(viewTemplateModel, viewModel: dataContext) : null;
    }

    //if name is missing throw exception
    else if(annotation != null && name == null) { //TODO refactor exceptions -> use errors?
      throw new MissingModuleIdException();
    }

    //if given type isn't a module throw exception
    else {
      throw new InvalidModuleException(new Symbol(name));
    }
  }

  /**
   * This event handler is invoked when the module will be created,
   * but before the template of the module is added to the DOM.
   */
  void onBeforeAdd(NavigationEventArgs args) {
    var method = _instance.methods.firstWhereMetadata((name, meta) => name == #OnBeforeAddAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke([args]);
    }
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded(NavigationEventArgs args) {
    var method = _instance.methods.firstWhereMetadata((name, meta) => name == #OnAddedAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke([args]);
    }
  }

  /**
   * This event handler is invoked when the module
   * will be destroyed but before the template
   * is removed from DOM.
   */
  void onBeforeRemove() {
    var method = _instance.methods.firstWhereMetadata((name, meta) => name == #OnBeforeRemoveAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke();
    }
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved() {
    var method = _instance.methods.firstWhereMetadata((name, meta) => name == #OnRemovedAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke();
    }
  }

  /**
   * This event handler is invoked whenever a request
   * is completed in case the request was successful but
   * also when an error occurred.
   */
  void onRequestCompleted(RequestCompletedEventArgs args) {
    var method = _instance.methods.firstWhereMetadata(
      (name, meta) => name == #OnRequestCompleted && (meta as OnRequestCompleted).isExecutable(args),
      orElse: () => null
    );

    if(method != null) {
      method.invoke([args]);
    }
  }

  /**
   * This event handler is invoked whenever the loading state is
   * changed. For example if the module starts to load
   * data or receives data.
   */
  void onLoadingStateChanged(LoadingStateChangedEventArgs args) {
    var method = _instance.methods.firstWhereMetadata(
      (name, meta) => name == #OnLoadingStateChanged && (meta as OnLoadingStateChanged).isExecutable(args),
      orElse: () => null
    );

    if(method != null) {
      method.invoke([args]);
    }
  }

}

class ModuleExistsWarning extends utility.WarningMessage {
  final String _fragmentId;
  final String _moduleId;

  ModuleExistsWarning(String namespace, String moduleId, String fragmentId) : _fragmentId = fragmentId, _moduleId = moduleId, super(namespace);

  @override
  String get message =>
    "Module with ID => \"$_moduleId\" is already added to fragment with ID => \"$_fragmentId\". You have to fix the duplicate to ensure that the application works as expected.";
}

const Object DataContext = const DataContextAnnotation();

class DataContextAnnotation {
  const DataContextAnnotation();
}