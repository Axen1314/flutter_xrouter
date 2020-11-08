import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dartpoet/dartpoet.dart';

bool thisOrAncestorTypeOfTarget(InterfaceType source, TypeToken target) {
  while (source != null) {
    String superClassName = source.toString();
    if (superClassName == target.toString()) {
      return true;
    }
    source = source.superclass;
  }
  return false;
}

bool isSupportAnnotatedClass(Element element, TypeToken supportAnnotatedElementType) {
  ClassElement classElement = element as ClassElement;
  var interfaceType = classElement.thisType;
  return thisOrAncestorTypeOfTarget(interfaceType, supportAnnotatedElementType);
}

bool isSubClassOf(InterfaceType source, String superDependency, String superClassName) {
  while (source != null) {
    InterfaceType sourceSuper = source.superclass;
    String sourceName = sourceSuper.toString();
    String sourceDependency = sourceSuper.element.librarySource.uri.toString();
    if (superDependency == sourceDependency && sourceName == superClassName) {
      return true;
    }
    source = sourceSuper;
  }
  return false;
}