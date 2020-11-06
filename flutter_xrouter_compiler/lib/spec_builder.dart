import 'dart:collection';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:source_gen/source_gen.dart';

import 'constants.dart';

abstract class SpecBuilder<T extends Spec> {
  final Map<String, DependencySpec> dependencies = HashMap();

  void putDependency(String key, DependencySpec spec) {
    dependencies.putIfAbsent(key, () => spec);
  }

  void _putDependencies(Map<String, DependencySpec> specs) {
    specs.forEach((key, value) => dependencies.putIfAbsent(key, () => value));
  }

  T build();
}

class FileSpecBuilder extends SpecBuilder<FileSpec> {
  final List<MethodSpec> _methods = List();
  final List<ClassSpec> _classes = List();

  void addMethod(SpecBuilder<MethodSpec> builder) {
    _methods.add(builder.build());
    _putDependencies(builder.dependencies);
  }

  void addClass(SpecBuilder<ClassSpec> builder) {
    _classes.add(builder.build());
    _putDependencies(builder.dependencies);
  }

  @override
  FileSpec build() {
    return FileSpec.build(
        classes: _classes,
        methods: _methods,
        dependencies: dependencies.values.toList());
  }
}

class ClassSpecBuilder extends SpecBuilder<ClassSpec> {
  String _className;
  ClassSpecBuilder(this._className): assert(_className != null);
  List<PropertySpec> _properties = List();
  CodeBlockSpec _constructCodeBlock = CodeBlockSpec.line("");

  void addProperty(PropertySpecBuilder builder) {
    _properties.add(builder.build());
    _constructCodeBlock.addLines(builder.initializeCodes);
    _putDependencies(builder.dependencies);
  }

  void addProperties(Iterable<PropertySpecBuilder> builders) {
    for (PropertySpecBuilder builder in builders) {
      if (builder.initializeCodes.isNotEmpty)
        addProperty(builder);
    }
  }

  @override
  ClassSpec build() {
    return ClassSpec.build(_className,
        constructorBuilder:
            (ClassSpec owner) => Set()..add(ConstructorSpec.normal(owner, codeBlock: _constructCodeBlock)),
        properties: _properties);
  }

}

class PropertySpecBuilder extends SpecBuilder<PropertySpec> {
  String propertyName;
  TypeToken valueType = TypeToken.ofDynamic();
  TypeToken supportAnnotatedElementType;
  ElementKind supportAnnotatedElementKind;
  List<String> initializeCodes = List();
  String Function(String builder) elementInitializeCode;
  List<DependencySpec> Function() extrasDependencySpecs;

  PropertySpecBuilder(
      this.propertyName, {
        this.valueType,
        this.supportAnnotatedElementType,
        this.supportAnnotatedElementKind:ElementKind.CLASS,
        this.elementInitializeCode,
        this.extrasDependencySpecs
      })
  {
    assert(propertyName != null);
    if (this.valueType == null)
      this.valueType = TypeToken.ofDynamic();
    if (this.supportAnnotatedElementType == null)
      this.supportAnnotatedElementType = this.valueType;
    if (this.elementInitializeCode == null)
      this.elementInitializeCode = (String className) => "$className();";
  }

  bool _isSupportAnnotatedElement(Element element) {
    if (element.kind == supportAnnotatedElementKind) {
      ClassElement classElement = element as ClassElement;
      var interfaceType = classElement.supertype;
      while (interfaceType != null) {
        String superClassName = interfaceType.toString();
        if (superClassName == supportAnnotatedElementType.toString()) {
          return true;
        }
        interfaceType = interfaceType.superclass;
      }
    }
    return false;
  }

  bool addElement(Element element, ConstantReader annotation) {
    if (_isSupportAnnotatedElement(element)) {
      DartObject obj = annotation.objectValue;
      String path = obj.getField(Parameter.PATH).toStringValue();
      int port = obj.getField(Parameter.PORT).toIntValue();
      String className = element.name;
      String sourceUri = element.librarySource.uri.toString();
      putDependency(sourceUri, DependencySpec.import(sourceUri));
      initializeCodes.add("$propertyName[\"$path:$port\"] = ${elementInitializeCode(className)}");
      return true;
    }
    return false;
  }

  @override
  PropertySpec build() {
    if (extrasDependencySpecs != null) {
      List<DependencySpec> extrasDependencies = extrasDependencySpecs();
      for (DependencySpec extrasDependency in extrasDependencies) {
        putDependency(extrasDependency.route, extrasDependency);
      }
    }
    return PropertySpec.ofMapByToken(propertyName,
        keyType: TypeToken.ofString(),
        valueType: valueType
    );
  }
}

class MethodSpecBuilder extends SpecBuilder<MethodSpec> {
  String methodName;
  bool isStatic;
  TypeToken valueType;

  MethodSpecBuilder(
      this.methodName, {
        this.valueType,
        this.isStatic
      });

  @override
  MethodSpec build() {
    return MethodSpec.build(
        methodName,
        returnType: TypeToken.ofMapByToken(TypeToken.ofString(), valueType),
        isStatic: isStatic);
  }

}