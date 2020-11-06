library flutter_xrouter_compiler;

import 'dart:async';

import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';
import 'package:flutter_xrouter_compiler/spec_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'constants.dart';


class XRouterCompiler extends Generator {
  TypeChecker get typeChecker => TypeChecker.fromRuntime(XRoute);
  static Set<PropertySpecBuilder> propertySpecBuilders = {
//    ClassPropertySpecBuilder(Property.WIDGET_BUILDERS,
//        valueType: TypeToken.of(Function),
//        supportAnnotatedElementType: TypeToken.ofFullName(Class.WIDGET),
//        elementInitializeCode: (String elementName) => "(_) => $elementName();"),
//    ClassPropertySpecBuilder(Property.ROUTE_LOADERS,
//        valueType: TypeToken.ofFullName(Class.ROUTE_LOADER)),
    FunctionPropertySpecBuilder(Property.WIDGET_GETTERS,
        elementInitializeCode: (String elementName) => "$elementName;")
  };

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep step) {
    if (propertySpecBuilders.isEmpty) return null;
    Iterable<AnnotatedElement> elements = library.annotatedWith(typeChecker);
    if (elements.isEmpty) return null;
    for (var rootElement in elements)
      for (PropertySpecBuilder builder in propertySpecBuilders)
        if (builder.addElement(rootElement.element, rootElement.annotation)) break;
    ClassSpecBuilder classBuilder = ClassSpecBuilder(Class.XROUTER_CACHE)..addProperties(propertySpecBuilders);
    FileSpecBuilder file = FileSpecBuilder()..addClass(classBuilder);
    DartFile dartFile = DartFile.fromFileSpec(file.build());
    return dartFile.outputContent();
  }

}
