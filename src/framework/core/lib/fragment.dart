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

  void _loadModules(List<String> moduleIds) { //TODO use ModuleDefinition instead of String
    for(var def in moduleIds) {

      _modules.add(
          new AnnotatedModule.from(
            def.libraryName,
            def.moduleName,
            _id,
            def.config
          )
      );
    }
  }
}
