library modularity.core.utility.string;

/**
 * Checks whether a [String] is null or empty.
 * If so it returns true, otherwise false
 */
bool isEmpty(String str) {
  return str == null || str.isEmpty;
}
