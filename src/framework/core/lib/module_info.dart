part of lib.core;

@deprecated
class ModuleInfo { //TODO remove class
  final String author;
  final String company;
  final String eMail;
  final String website;
  String _version;

  ModuleInfo(String version, {this.author, this.company, this.eMail, this.website}) {
    if(_validateVersion(version)) {
      _version = version;
    } else {
      //TODO throw invalid version number exception
    }
  }

  bool _validateVersion(String version) {
    return true; //TODO implement version number validation
  }
}
