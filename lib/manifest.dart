library modularity.core.manifest;

import 'data/data.dart' show Converter;
import 'dart:convert' show JSON;

class Manifest {
  ApplicationModel _config;

  Manifest.fromJson(String json) {
    _config = new ApplicationConverter().convert(JSON.decode(json));
  }

  ApplicationModel get config => _config;
}

//################################## application
class ApplicationModel {
  String startUri;
  String language;
  String version;
  String author; //TODO model for author? which contains more info than the name
  String name;
  String rootId;
  List<PageModel> pages;
}

class ApplicationConverter implements Converter<Map, ApplicationModel> {
  static const String startUriKey = "startUri";
  static const String languageKey = "language";
  static const String versionKey = "version";
  static const String authorKey = "author";
  static const String pagesKey = "pages";
  static const String nameKey = "name";
  static const String rootIdKey = "rootId";

  @override
  ApplicationModel convert(Map value) {
    var pageList = value[pagesKey];
    var pages = new List<PageModel>();

    if(pageList != null && pageList is List) {
      var converter = new PageConverter();

      for(var page in pageList) {
        pages.add(converter.convert(page));
      }
    }

    return new ApplicationModel()
      ..startUri = value[startUriKey]
      ..language = value[languageKey]
      ..version = value[versionKey]
      ..author = value[authorKey]
      ..name = value[nameKey]
      ..rootId = value[rootIdKey]
      ..pages = pages;
  }

  @override
  Map convertBack(ApplicationModel value) {
    throw new UnimplementedError();
  }
}

//################################## page
class PageModel {
  String uri;
  String title;
  ViewTemplateModel template;
  List<FragmentModel> fragments;
}

class PageConverter implements Converter<Map, PageModel> {
  static const String fragmentsKey = "fragments";
  static const String templateKey = "template";
  static const String titleKey = "title";
  static const String uriKey = "uri";

  @override
  PageModel convert(Map value) {
    var template = value[templateKey] != null ? new ViewTemplateConverter().convert(value[templateKey]) : null;

    var fragmentList = value[fragmentsKey];
    var fragments = new List<FragmentModel>();

    if(fragmentList != null && fragmentList is List) {
      var converter = new FragmentConverter();

      for(var fragment in fragmentList) {
        fragments.add(converter.convert(fragment));
      }
    }

    return new PageModel()
      ..uri = value[uriKey]
      ..title = value[titleKey]
      ..template = template
      ..fragments = fragments;
  }

  @override
  Map convertBack(PageModel value) {
    throw new UnimplementedError();
  }
}

//################################## fragment
class FragmentModel {
  String parentId;
  List<ModuleModel> modules;
}

class FragmentConverter implements Converter<Map, FragmentModel> {
  static const String parentIdKey = "parentId";
  static const String modulesKey = "modules";

  @override
  FragmentModel convert(Map value) {
    var moduleList = value[modulesKey];
    var modules = new List<ModuleModel>();

    if(moduleList != null && moduleList is List) {
      var converter = new ModuleConverter();

      for(var module in moduleList) {
        modules.add(converter.convert(module));
      }
    }

    return new FragmentModel()
      ..parentId = value[parentIdKey]
      ..modules = modules;
  }

  @override
  Map convertBack(FragmentModel value) {
    throw new UnimplementedError();
  }
}

//################################## module
class ModuleModel {
  String lib;
  String name;
  Map<String, dynamic> attributes;
}

class ModuleConverter implements Converter<Map, ModuleModel> {
  static const String attributesKey = "attributes";
  static const String libraryNameKey = "lib";
  static const String nameKey = "name";

  @override
  ModuleModel convert(Map value) {
    return new ModuleModel()
      ..lib = value[libraryNameKey]
      ..name = value[nameKey]
      ..attributes = value[attributesKey];
  }

  @override
  Map convertBack(ModuleModel value) {
    throw new UnimplementedError();
  }
}

//################################## view template
class ViewTemplateModel {
  String lib;
  String type;
  List<ViewBindingModel> attributes;
  List<ViewBindingModel> events;
  List<ViewTemplateModel> subviews;
}

class ViewBindingModel {
  String attributeName;
  String propertyName;
  dynamic defaultValue;
}

class ViewTemplateConverter implements Converter<Map, ViewTemplateModel> {
  static const String attributesKey = "attributes";
  static const String subviewsKey = "subviews";
  static const String eventsKey = "events";
  static const String libraryKey = "lib";
  static const String typeKey = "type";
  static const String nameKey = "name";
  static const String valueKey = "value";
  static const String bindingKey = "binding";

  @override
  ViewTemplateModel convert(Map jsonMap) {
    var attributes = new List<ViewBindingModel>();
    var events = new List<ViewBindingModel>();
    var subviews = new List<ViewTemplateModel>();

    var libraryName = jsonMap[libraryKey];
    var viewType = jsonMap[typeKey];

    var attributesList = jsonMap[attributesKey];
    if(attributesList != null && attributesList is List) {
      for(var attribute in attributesList) {
        attributes.add(_parseAttributeBinding(attribute));
      }
    }

    var eventsList = jsonMap[eventsKey];
    if(eventsList != null && eventsList is List) {
      for(var event in eventsList) {
        events.add(_parseEventHandlerBinding(event));
      }
    }

    var subviewsList = jsonMap[subviewsKey];
    if(subviewsList != null && subviewsList is List) {
      for(var subview in subviewsList) {
        subviews.add(convert(subview));
      }
    }

    return new ViewTemplateModel()
      ..lib = libraryName
      ..type = viewType
      ..attributes = attributes
      ..events = events
      ..subviews = subviews;
  }

  //view == attribute
  //viewModel == property
  ViewBindingModel _parseEventHandlerBinding(Map event) {
    var eventHandlerName = event[bindingKey];
    var attributeName = event[nameKey];

    return new ViewBindingModel()
      ..attributeName = attributeName
      ..propertyName = eventHandlerName;
  }

  ViewBindingModel _parseAttributeBinding(Map attribute) {
    var attributeName = attribute[nameKey];
    var propertyName = attribute[bindingKey];
    var defaultValue = attribute[valueKey];

    return new ViewBindingModel()
      ..attributeName = attributeName
      ..propertyName = propertyName
      ..defaultValue = defaultValue;
  }

  @override
  Map convertBack(ViewTemplateModel value) {
    throw new UnimplementedError();
  }

}

