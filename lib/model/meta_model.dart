part of modularity.core.model;

/**
 * Model which contains all meta
 * information, especially
 * those for pagination.
 */
class MetaModel {
  int offset;
  int limit;
  int filteredCount;
  int totalCount;
  String next;
  String previous;
}
