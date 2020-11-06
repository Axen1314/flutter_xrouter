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
  var interfaceType = classElement.thisType;
  return _thisOrAncestorTypeOfTarget(interfaceType, supportAnnotatedElementType);
}