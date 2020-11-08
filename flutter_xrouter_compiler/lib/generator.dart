library flutter_xrouter_compiler;

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:flutter_xrouter_annotation/annotation.dart';
import 'package:flutter_xrouter_compiler/spec.dart';
import 'package:flutter_xrouter_compiler/utils.dart';
import 'package:source_gen/source_gen.dart';

import 'constants.dart';


class XRElementGenerator extends GeneratorForAnnotation<XRoute> {
  TypeChecker get typeChecker => TypeChecker.fromRuntime(XRoute);
  static CodeBlockSpec constructor = CodeBlockSpec.line("");

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind == ElementKind.FUNCTION) {
      DartObject obj = annotation.objectValue;
      String path = obj.getField(Parameter.PATH).toStringValue();
      int port = obj.getField(Parameter.PORT).toIntValue();
      constructor.addLine("addElementLoader(\"$path\", ${element.name}, port: $port);");
    }
    return null;
  }
}

class XRFileGenerator extends GeneratorForAnnotation<XRouteRoot> {
  bool isFileGenerated = false;

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (isFileGenerated) return null;
    if (element.kind == ElementKind.CLASS) {
      ClassElement classElement = element as ClassElement;
      if (isSubClassOf(classElement.thisType,
          Dependency.XROUTER, Class.IXROUTER_LOADER)) {
        ClassSpec classSpec = ClassSpec.build(Class.XROUTER,
            superClass: TypeToken.ofFullName(Class.ABSTRACT_XROUTER),
            constructorBuilder: (ClassSpec owner) => {
              ConstructorSpec.named(owner, "_internal", codeBlock: XRElementGenerator.constructor),
              ConstructorSpec.namedFactory(owner, "of",
                  parameters: [
                    ParameterSpec.normal("context", type: TypeToken.ofFullName(Class.BUILD_CONTEXT))
                  ],
                  codeBlock: CodeBlockSpec.line("_ensureInstanceInitialize();")
                    ..addLine("_instance.context = context;")
                    ..addLine("return _instance;"))
            },
            properties: [
              ExtendedPropertySpec.of("_instance", isStatic: true, type: TypeToken.ofFullName(Class.XROUTER))
            ],
            methods: [
              MethodSpec.build("_ensureInstanceInitialize",
                  isStatic: true,
                  codeBlock: CodeBlockSpec.line("if (_instance == null)")
                    ..addLine("_instance = XRouter._internal();")
              ),
              MethodSpec.build("handleRoute",
                  isStatic: true,
                  returnType: TypeToken.ofFullName("Route"),
                  parameters: [
                    ParameterSpec.normal("settings", type: TypeToken.ofFullName("RouteSettings"))
                  ],
                  codeBlock: CodeBlockSpec.line("_ensureInstanceInitialize();")
                    ..addLine("return _instance.handleOnGenerateRoute(settings);"))
            ],
            getters: [
              GetterSpec.build(Getter.ROUTER_LOADER,
                  type: TypeToken.ofFullName(Class.IXROUTER_LOADER),
                  codeBlock: CodeBlockSpec.line("${element.name}();"))
            ]);
        FileSpec fileSpec = FileSpec.build(
            dependencies: [
              DependencySpec.import(Dependency.XROUTER),
              DependencySpec.import(element.librarySource.uri.toString()),
              DependencySpec.import(Dependency.WIDGETS)
            ],
            classes: [classSpec]
        );
        DartFile dartFile = DartFile.fromFileSpec(fileSpec);
        isFileGenerated = true;
        return dartFile.outputContent();
      }
    }
    return null;
  }


}


