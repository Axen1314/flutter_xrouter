library flutter_xrouter_annotation;

class XRoute {
  final int port;
  final String path;
  const XRoute(this.path, {this.port:80});
}

class Path {
  final String path;
  final int port;
  Path(this.path, {this.port:80});
}

class XRouteRoot {
  const XRouteRoot();
}
