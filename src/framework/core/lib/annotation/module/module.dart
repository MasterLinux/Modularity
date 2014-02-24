library lib.core.annotation.module;

part 'on_added.dart';
part 'on_before_add.dart';
part 'on_before_remove.dart';
part 'on_init.dart';
part 'on_loading_state_changed.dart';
part 'on_removed.dart';
part 'on_request_completed.dart';

/**
 * Annotation which marks a class as module.
 */
class Module {
  final String author;
  final String company;
  final String eMail;
  final String website;
  final String version;

  const Module(this.version, {this.author, this.company, this.eMail, this.website});
}
