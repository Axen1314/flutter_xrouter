// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// XRFileGenerator
// **************************************************************************

import 'package:flutter_xrouter_library/xrouter.dart';
import 'package:example/loader.dart';
import 'package:flutter/widgets.dart';

class XRouter extends AbstractXRouter {
  static XRouter _instance;

  XRouter._internal() {
    addElementLoader("home", home, port: 80);
    addElementLoader("home/login", login, port: 80);
  }
  factory XRouter.of(BuildContext context) {
    _ensureInstanceInitialize();
    _instance.context = context;
    return _instance;
  }

  IXRouterLoader get routerLoader => CommonXRouterLoader();

  static _ensureInstanceInitialize() {
    if (_instance == null) _instance = XRouter._internal();
  }

  static Route handleRoute(RouteSettings settings) {
    _ensureInstanceInitialize();
    return _instance.handleOnGenerateRoute(settings);
  }
}
