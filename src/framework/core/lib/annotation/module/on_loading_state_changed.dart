part of lib.core.annotation.module;

class OnLoadingStateChanged {
  final bool isLoading;

  const OnLoadingStateChanged({this.isLoading});

  bool get isDefault => isLoading == null;
}
