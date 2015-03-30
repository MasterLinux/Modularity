part of modularity.core;

/**
 * Helper class to load and handle annotated
 * modules. This class is used to load
 * modules with the help of its library
 * and class name.
 */
class Module { // TODO rename to ModuleLoader
  final Map<String, dynamic> attributes;
  final ViewTemplateModel viewTemplateModel;
  final ApplicationContext context;
  final Fragment fragment;
  final String libraryName;
  final String name;

  //ApplicationContext _context;
  Field _dataContextField;
  ViewTemplate _template;
  ClassLoader _classLoader;

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

  ViewModel get dataContext => _dataContextField.get();

  /**
   * Initializes the module with the help
   * of a class which uses module annotations.
   */
  Module(this.libraryName, this.name, this.viewTemplateModel, this.attributes, this.fragment, this.context) {
    _classLoader = new ClassLoader(new Symbol(libraryName), new Symbol(name));
    onInit(new InitEventArgs(attributes));
  }

  Future load() async {
    await _classLoader.load();
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
  void onInit(InitEventArgs args) {
    var annotation = _classLoader.metadata[#ApplicationModule];

    //get module information for registration
    if(annotation != null) {
      _meta = annotation as annotations.ApplicationModule;
      _dataContextField = _classLoader.fields.firstWhereMetadata((name, meta) => name == #DataContextAnnotation, orElse: () => null);
      _template = template != null ? new ViewTemplate.fromModel(viewTemplateModel, viewModel: dataContext) : null;

      var onInitMethod = _classLoader.methods.firstWhereMetadata((name, meta) => name == #OnInitAnnotation, orElse: () => null);

      //try to invoke onInit handler of module, if handler doesn't exists throw exception
      if(onInitMethod != null) {
        onInitMethod.invoke([context, args]);
      } else {
        throw new MissingInitMethodException(name);
      }
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
    var method = _classLoader.methods.firstWhereMetadata((name, meta) => name == #OnBeforeAddAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke([args]);
    }
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely added to DOM.
   */
  void onAdded(NavigationEventArgs args) {
    var method = _classLoader.methods.firstWhereMetadata((name, meta) => name == #OnAddedAnnotation, orElse: () => null);

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
    var method = _classLoader.methods.firstWhereMetadata((name, meta) => name == #OnBeforeRemoveAnnotation, orElse: () => null);

    if(method != null) {
      method.invoke();
    }
  }

  /**
   * This event handler is invoked when the template
   * of the module is completely removed from DOM.
   */
  void onRemoved() {
    var method = _classLoader.methods.firstWhereMetadata((name, meta) => name == #OnRemovedAnnotation, orElse: () => null);

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
    var method = _classLoader.methods.firstWhereMetadata(
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
    var method = _classLoader.methods.firstWhereMetadata(
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