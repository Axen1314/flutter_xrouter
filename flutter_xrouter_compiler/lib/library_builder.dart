import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'compiler.dart';

Builder routeBuilder(BuilderOptions options) => LibraryBuilder(XRouterCompiler());
