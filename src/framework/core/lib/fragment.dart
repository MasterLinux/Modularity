part of lib.core;

class Fragment {
  List<AbstractModule> _modules;
  String _id;

  /**
   * Prefix used for the node ID
   */
  final String ID_PREFIX = "fragment";

  Fragment() {
    _id = new UniqueId(ID_PREFIX).build();
    _modules = [];
  }

  //TODO implement ID getter

  void _loadModules(List<ModuleConfig> moduleConfig) { //TODO use ModuleDefinition instead of String

    //creates all modules of this fragment
    for(var config in moduleConfig) {
      _modules.add(
          new AnnotatedModule(
            config.libraryName,
            config.moduleName,
            _id,
            config.config
          )
      );
    }
  }
}
