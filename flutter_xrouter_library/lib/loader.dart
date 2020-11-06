
import 'package:flutter/widgets.dart';

abstract class RouteLoader {
  Route<dynamic> onRouteLoad(RouteSettings settings);
}