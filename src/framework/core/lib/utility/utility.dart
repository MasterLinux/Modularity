library lib.core.utility;

import '../exception/exception.dart';
import 'dart:mirrors';

part 'unique_id.dart';

/**
 * Gets the mirror of a specific class with the help of
 * its [libraryName] and [className].
 */
ClassMirror getClassMirror(String libraryName, String className) {
  Symbol librarySymbol = new Symbol(libraryName); //TODO is the usage of const Symbol('') possible?
  Symbol classSymbol = new Symbol(className); //TODO is the usage of const Symbol('') possible?
  ClassMirror reflectedClass;

  //get current mirror system
  var mirrors = currentMirrorSystem();

  //get required library mirror
  var libraryMirror = mirrors.libraries.values.firstWhere(
          (libraryMirror) => libraryMirror.qualifiedName == librarySymbol,
      orElse: () => null
  );

  if(libraryMirror != null &&
  (reflectedClass = libraryMirror.declarations[classSymbol]) != null) {
    return reflectedClass;

  } else if(libraryMirror != null && reflectedClass == null) {
    throw new MissingModuleException(className);
  } else {
    throw new MissingLibraryException(libraryName);
  }
}