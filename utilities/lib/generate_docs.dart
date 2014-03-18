import 'package:args/args.dart';
import "package:path/path.dart" show dirname;
import 'dart:core';
import 'dart:io';

/**
 * Utility class to generate the documentation
 * of the whole project.
 */
class DocBuilder {
  List<String> _dartDocs;
  List<String> _javaDocs;

  static const DEFAULT_OUTPUT_PATH = "docs/core";
  static const DEFAULT_OUTPUT_JAVA_PATH = "java";
  static const DEFAULT_OUTPUT_DART_PATH = "dart";

  static const FLAG_JAVA = "java";
  static const FLAG_DART = "dart";
  static const FLAG_JAVA_ABBR = "j";
  static const FLAG_DART_ABBR = "d";

  /**
   * Initializes the documentation builder
   */
  DocBuilder() {
    _dartDocs = [];
    _javaDocs = [];
  }

  /**
   * Builds all documentations
   */
  DocBuilder build({String outputPath}) {       //TODO use future?
    buildDartDocs(outputPath: outputPath);
    buildJavaDocs(outputPath: outputPath);
    return this;
  }

  DocBuilder add(String path, DocType type) {
    switch(type) {
      case DocType.DART:
        _dartDocs.add(path);
        break;

      case DocType.JAVA:
        _javaDocs.add(path);
        break;

      default:
        //TODO show warning that type isn't supported yet
        break;
    }

    return this;
  }

  void buildDartDocs({String outputPath}) {
    outputPath = outputPath != null ? outputPath : DEFAULT_OUTPUT_PATH;

    for(var path in _dartDocs) {
      //run dartdoc process
      /* deprecated command
      Process.run('dartdoc', ['--out', outputPath, path],  workingDirectory: '../../', runInShell: true).then((result) {
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });
      */

      Process.run('docgen', ['--out', outputPath, "--package-root", "src/framework/core/packages/", path],  workingDirectory: '../../', runInShell: true).then((result) {
        stdout.write(result.stdout);
        stderr.write(result.stderr);
      });

    }
  }

  void buildJavaDocs({String outputPath}) {
    outputPath = outputPath != null ? outputPath : DEFAULT_OUTPUT_PATH;

    for(var path in _javaDocs) {
      print(dirname(Platform.script.toString()));
      //TODO if path not exists show warning
      //TODO execute javadoc
    }
  }
}

/**
 * Collection of all supported doc types.
 */
class DocType {
  static const DART = const DocType._(0);
  static const JAVA = const DocType._(1);

  static get values => [DART, JAVA];

  final int value;

  const DocType._(this.value);
}

/**
 * Starts the build process of the
 * doc builder.
 */
void main(List<String> args) {
  final argParser = new ArgParser()
    ..addFlag(DocBuilder.FLAG_JAVA, abbr: DocBuilder.FLAG_JAVA_ABBR)
    ..addFlag(DocBuilder.FLAG_DART, abbr: DocBuilder.FLAG_DART_ABBR);

  var argResults = argParser.parse(args);

  //check whether flags are set
  var hasJavaFlag = argResults[DocBuilder.FLAG_JAVA];
  var hasDartFlag = argResults[DocBuilder.FLAG_DART];
  var buildAll = !hasJavaFlag && !hasDartFlag;

  //add all path to builder
  var builder = new DocBuilder()
    .add("src/framework/core/lib/core.dart", DocType.DART)
    .add("test/path2", DocType.JAVA);

  //build complete documentation
  if(buildAll) {
    builder.build(outputPath: null);
  }

  else {
    //build java doc
    if(argResults[DocBuilder.FLAG_JAVA]) {
      builder.buildJavaDocs(outputPath: null);
    }

    //build dart doc
    if(argResults[DocBuilder.FLAG_DART]) {
      builder.buildDartDocs(outputPath: null);
    }
  }
}