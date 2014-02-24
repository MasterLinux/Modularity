part of lib.core.annotation.module;

class OnRequestCompleted {
  final String requestId;
  final bool isErrorHandler;

  const OnRequestCompleted({this.requestId, this.isErrorHandler: false});

  bool get isDefault => requestId == null;
}
