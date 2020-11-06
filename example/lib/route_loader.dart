import 'package:flutter/widgets.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';

abstract class RouteLoader {
  Route onLoadRoute();
}

@XRoute("path/loader")
class SimpleRouteLoader extends RouteLoader {
  @override
  Route onLoadRoute() {
    print("11111");
    return null;
  }

}