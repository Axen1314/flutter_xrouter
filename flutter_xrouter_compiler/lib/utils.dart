import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dartpoet/dartpoet.dart';

bool _thisOrAncestorTypeOfTarget(InterfaceType source, TypeToken target) {
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
  var interfaceType = classElement.supertype;
  while (interfaceType != null) {
    String superClassName = interfaceType.toString();
    if (superClassName == supportAnnotatedElementType.toString()) {
      return true;
    }
    interfaceType = interfaceType.superclass;
  }
  return false;
}

bool isSupportAnnotatedClass2(Element element, TypeToken supportAnnotatedElementType) {
  ClassElement classElement = element as ClassElement;
  var interfaceType = classElement.thisType;
  return _thisOrAncestorTypeOfTarget(interfaceType, supportAnnotatedElementType);
}

bool isSupportAnnotatedMethod(Element element, TypeToken valueType) {
  MethodElement methodElement = element as MethodElement;
  var interfaceType = methodElement.returnType;
  return _thisOrAncestorTypeOfTarget(interfaceType, valueType);
}