import 'package:flutter/widgets.dart';
import 'package:flutter_xrouter_library/converter.dart';

typedef ElementLoader = dynamic Function(RouteSettings settings);

abstract class IXRouterLoader {
  List<IRouteConverter> onLoadRouteConverters() => null;
}

abstract class AbstractXRouter {

  AbstractXRouter() {
    IXRouterLoader loader = routerLoader;
    List<IRouteConverter> converters = loader.onLoadRouteConverters();
    if (converters != null && converters.isNotEmpty) {
      for (IRouteConverter converter in converters) {
        addConverter(converter);
      }
    }
  }
  BuildContext context;
  List<IRouteConverter> _converters = [
    SimpleWidgetConverter(),
    SimpleRoutePageBuilderConverter()
  ];
  Map<String, ElementLoader> _loaders = {};

  void addConverter(IRouteConverter converter) {
    _converters.insert(0, converter);
  }

  void addElementLoader(String path, ElementLoader loader, {int port:80}) {
    _loaders.putIfAbsent("$path:$port", () => loader);
  }

  Future<Object> push(String path, {int port:80, Object arguments}) {
    return Navigator.of(context).pushNamed("$path:$port", arguments: arguments);
  }

  void pop<T extends Object>([T result]) {
    Navigator.of(context).pop(result);
  }

  @protected
  Route handleOnGenerateRoute(RouteSettings settings) {
    String path = settings.name;
    if (!_loaders.containsKey(path)) {
      return null;
    }
    ElementLoader loader = _loaders[path];
    dynamic element = loader(settings);
    if (element is Route) return element;
    for (IRouteConverter converter in _converters) {
      if (converter.isConvertible(element)) {
        return converter.onConvert(settings, element);
      }
    }
    throw new FlutterError("Require converter to convert type ${element.runtimeType}!");
  }

  @protected
  IXRouterLoader get routerLoader;
}

