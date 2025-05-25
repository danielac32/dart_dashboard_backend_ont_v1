// generator/generator.dart

import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'annotations.dart';

class RouteGenerator extends GeneratorForAnnotation<Route> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final method = annotation.peek('method')!.stringValue;
    final path = annotation.peek('path')!.stringValue;

    return '''
      router.addRoute('$method', '$path', ${element.name});
    ''';
  }
}

Builder routeGenerator(BuilderOptions options) =>
    SharedPartBuilder([RouteGenerator()], 'routeGenerator');