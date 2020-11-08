import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';
import 'package:flutter_xrouter_library/xrouter.dart';

@XRouteRoot()
class CommonXRouterLoader extends IXRouterLoader {}

@XRoute("home")
Widget home(RouteSettings settings) => MyHomePage();

@XRoute("home/login")
Widget login(RouteSettings settings) => LoginPage();