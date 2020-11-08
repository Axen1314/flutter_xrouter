import 'package:dartpoet/dartpoet.dart';

class ExtendedPropertySpec extends PropertySpec {
  bool isStatic;

  ExtendedPropertySpec.of(String name, {
    DocSpec doc,
    this.isStatic,
    TypeToken type,
    dynamic defaultValue,
    List<MetaSpec> metas,
  }) : super.of(
      name,
      doc: doc,
      type: type,
      defaultValue: defaultValue,
      metas: metas);

  ExtendedPropertySpec.ofString(
      String name, {
        DocSpec doc,
        bool isStatic,
        String defaultValue,
        List<MetaSpec> metas,
      }) : this.of(
    name,
    doc: doc,
    isStatic: isStatic,
    type: TypeToken.ofString(),
    defaultValue: defaultValue,
    metas: metas,
  );

  ExtendedPropertySpec.ofInt(
      String name, {
        DocSpec doc,
        bool isStatic,
        int defaultValue,
        List<MetaSpec> metas,
      }) : this.of(
    name,
    doc: doc,
    isStatic: isStatic,
    type: TypeToken.ofInt(),
    defaultValue: defaultValue,
    metas: metas,
  );

  ExtendedPropertySpec.ofDouble(
      String name, {
        DocSpec doc,
        bool isStatic,
        double defaultValue,
        List<MetaSpec> metas,
      }) : this.of(
    name,
    doc: doc,
    isStatic: isStatic,
    type: TypeToken.ofDouble(),
    defaultValue: defaultValue,
    metas: metas,
  );

  ExtendedPropertySpec.ofBool(
      String name, {
        DocSpec doc,
        bool isStatic,
        bool defaultValue,
        List<MetaSpec> metas,
      }) : this.of(
    name,
    doc: doc,
    isStatic: isStatic,
    type: TypeToken.ofBool(),
    defaultValue: defaultValue,
    metas: metas,
  );

  static ExtendedPropertySpec ofListByToken(
      String name, {
        TypeToken componentType,
        DocSpec doc,
        bool isStatic,
        List defaultValue,
        List<MetaSpec> metas,
      }) {
    return ExtendedPropertySpec.of(name,
        type: TypeToken.ofListByToken(componentType ?? TypeToken.ofDynamic()),
        isStatic: isStatic,
        metas: metas,
        doc: doc,
        defaultValue: defaultValue);
  }

  static ExtendedPropertySpec ofList<T>(
      String name, {
        DocSpec doc,
        bool isStatic,
        List defaultValue,
        List<MetaSpec> metas,
      }) {
    return ofListByToken(name, doc: doc, isStatic: isStatic, defaultValue: defaultValue, metas: metas, componentType: TypeToken.of(T));
  }

  static ExtendedPropertySpec ofMapByToken(
      String name, {
        TypeToken keyType,
        TypeToken valueType,
        DocSpec doc,
        bool isStatic,
        Map defaultValue,
        List<MetaSpec> metas,
      }) {
    return ExtendedPropertySpec.of(name,
        type: TypeToken.ofMapByToken(keyType, valueType), metas: metas, isStatic: isStatic, doc: doc, defaultValue: defaultValue);
  }

  static ExtendedPropertySpec ofMap<K, V>(
      String name, {
        DocSpec doc,
        bool isStatic,
        Map defaultValue,
        List<MetaSpec> metas,
      }) {
    return ofMapByToken(name,
        keyType: TypeToken.of(K), valueType: TypeToken.of(V), metas: metas, doc: doc, isStatic: isStatic, defaultValue: defaultValue);
  }

  @override
  String code({Map<String, dynamic> args = const {}}) {
    String superCode = super.code(args: args);
    return isStatic ? "static $superCode" : superCode;
  }

}