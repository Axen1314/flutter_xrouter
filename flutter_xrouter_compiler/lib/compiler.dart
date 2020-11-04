library flutter_xrouter_compiler;

import 'dart:async';

import 'package:dartpoet/dartpoet.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';
import 'package:flutter_xrouter_compiler/spec_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'constants.dart';


class XRouterCompiler extends Generator {

  TypeChecker get typeChecker => TypeChecker.fromRuntime(XRoute);

  @override
  FutureOr<String> generate(LibraryReader library, _) {
    Iterable<AnnotatedElement> elements = library.annotatedWith(typeChecker);
    if (elements.isNotEmpty) {
      RoutePropertySpecBuilder widgetBuilderBuilder = RoutePropertySpecBuilder();
      for (var rootElement in elements) {
        widgetBuilderBuilder.addTargetValue(rootElement.element, rootElement.annotation);
      }
      ClassSpecBuilder classBuilder = ClassSpecBuilder(Class.XROUTER_CACHE)..addProperty(widgetBuilderBuilder);
      FileSpecBuilder file = FileSpecBuilder()..addClass(classBuilder);
      DartFile dartFile = DartFile.fromFileSpec(file.build());
      return dartFile.outputContent();
    }
    return null;
  }
  
}
