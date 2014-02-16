part of lib.core.utility;

class UniqueId {
  static Map<String, UniqueId> _cache;
  String _prefix;
  int _prevId;

  factory UniqueId(String prefix) {
    if(_cache == null) {
      _cache = <String, UniqueId>{};
    }

    if(_cache.containsKey(prefix)) {
      return _cache[prefix];
    } else {
      final uniqueId = new UniqueId._internal(prefix);
      _cache[prefix] = uniqueId;
      return uniqueId;
    }
  }

  UniqueId._internal(String prefix) {
    _prefix = prefix;
    _prevId = 0;
  }

  String getUniqueId() {
    var id = '${_prefix}_${_prevId}';
    ++_prevId;
    return id;
  }
}
