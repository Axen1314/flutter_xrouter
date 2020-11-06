import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';

abstract class RouteLoader {
  Route onLoadRoute();
}

@XRoute("path/ok")
Widget login(RouteSettings settings) => MyHomePage();