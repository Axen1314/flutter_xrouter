import 'package:flutter/widgets.dart';
import 'package:flutter_xrouter_library/handler.dart';

class XRouter {
  XRouter._();
  static XRouter _instance;

  BuildContext _context;
  List<IRouteHandler> handlers = [
    SimpleWidgetHandler(),
    SimpleRoutePageBuilderHandler()
  ];

  factory XRouter.of(BuildContext context) {
    assert(context != null);
    _ensureXRouterInitialize();
    _instance._context = context;
    return _instance;
  }

  void addHandler(IRouteHandler handler) {
    handlers.insert(0, handler);
  }

  static void _ensureXRouterInitialize() {
    if (_instance == null)
      _instance = XRouter._();
  }

  void push(String path, {int port:80, Object arguments}) {
    Navigator.pushNamed(_context, "$path:$port", arguments: arguments);
  }

  void pop<T extends Object>([T result]) {
    Navigator.of(_context).pop(result);
  }

  void handleOnGenerateRoute(RouteSettings settings) {

  }
}