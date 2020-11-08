
import 'package:flutter/widgets.dart';

abstract class IRouteConverter<T> {
  Route onConvert(RouteSettings settings, T element);
  bool isConvertible(dynamic element) => element is T;
}

class SimpleWidgetConverter extends IRouteConverter<Widget> {
  @override
  Route onConvert(RouteSettings settings, Widget element) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) => element
    );
}

class SimpleRoutePageBuilderConverter extends IRouteConverter<RoutePageBuilder> {
  @override
  Route onConvert(RouteSettings settings, RoutePageBuilder element) => PageRouteBuilder(
    settings: settings,
    pageBuilder: element
  );
}