part of lib.core;

class Fragment {
  List<AbstractModule> _modules;

  Fragment() {
    _modules = [];
  }

  void _loadModules(List<String> moduleIds) {
    for(var id in moduleIds) {
      var symbol = new Symbol(id);

      _modules.add(new AnnotatedModule.from());
    }
  }
}
