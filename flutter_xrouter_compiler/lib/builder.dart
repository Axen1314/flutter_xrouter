import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';

Builder elementBuilder(BuilderOptions options) => LibraryBuilder(XRElementGenerator());

Builder fileBuilder(BuilderOptions options) => LibraryBuilder(XRFileGenerator(), generatedExtension: ".internal.dart");
