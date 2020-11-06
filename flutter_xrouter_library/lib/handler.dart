import 'package:flutter/widgets.dart';

abstract class IRouteHandler<T> {
  Route onHandleRoute(RouteSettings settings, T element);
}

class SimpleWidgetHandler extends IRouteHandler<Widget> {
  @override
  Route onHandleRoute(RouteSettings settings, Widget element) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (BuildContext context, 
            Animation<double> animation, 
            Animation<double> secondaryAnimation) => element
    );
}

class SimpleRoutePageBuilderHandler extends IRouteHandler<RoutePageBuilder> {
  @override
  Route onHandleRoute(RouteSettings settings, RoutePageBuilder element) => PageRouteBuilder(
    settings: settings,
    pageBuilder: element
  );
}