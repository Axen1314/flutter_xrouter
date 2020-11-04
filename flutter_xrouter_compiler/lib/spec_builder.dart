import 'dart:collection';

import 'package:dartpoet/dartpoet.dart';
import 'file:///E:/WorkSpace/flutter_xrouter/flutter_xrouter_compiler/lib/constants.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

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
  CodeBlockSpec _constructCodeBlock = CodeBlockSpec.empty();

  void addProperty(PropertySpecBuilder builder) {
    _properties.add(builder.build());
    _constructCodeBlock.addLines(builder.initLines());
    _putDependencies(builder.dependencies);
  }

  @override
  ClassSpec build() {
    return ClassSpec.build(_className,
        constructorBuilder: (ClassSpec owner) => Set()..add(ConstructorSpec.normal(owner, codeBlock: _constructCodeBlock)),
        properties: _properties);
  }

}

abstract class PropertySpecBuilder extends SpecBuilder<PropertySpec> {
  bool _isTargetElement(Element element);
  void _addValue(String path, int port, String widget);
  void addTargetValue(Element element, ConstantReader annotation) {
    if (_isTargetElement(element)) {
      DartObject obj = annotation.objectValue;
      String path = obj.getField(Parameter.PATH).toStringValue();
      int port = obj.getField(Parameter.PORT).toIntValue();
      String widget = element.name;
      String sourceUri = element.librarySource.uri.toString();
      putDependency(sourceUri, DependencySpec.import(sourceUri));
      _addValue(path, port, widget);
    }
  }
  List<String> initLines();
}

class RoutePropertySpecBuilder extends PropertySpecBuilder {
  List<String> _widgets = List();

  @override
  PropertySpec build() {
    putDependency(Dependency.WIDGETS, DependencySpec.import(Dependency.WIDGETS));
    return PropertySpec.ofMapByToken(Property.ROUTES,
      keyType: TypeToken.ofString(),
      valueType: TypeToken.of(Function),
    );
  }

  @override
  bool _isTargetElement(Element element) => true;

  @override
  void _addValue(String path, int port, String widget) {
    _widgets.add("${Property.ROUTES}[\"$path:$port\"] = (BuildContext context) => $widget();");
  }

  @override
  List<String> initLines() {
    return _widgets;
  }

}