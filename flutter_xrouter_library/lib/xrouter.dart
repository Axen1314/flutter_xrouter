import 'package:flutter/cupertino.dart';

class XRouter {
  BuildContext _context;
  XRouter._(BuildContext context) {
    this._context = context;
  }

  factory XRouter.of(BuildContext context) {
    return XRouter._(context);
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