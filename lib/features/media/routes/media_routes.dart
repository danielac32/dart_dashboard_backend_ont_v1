


import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/media/controller/noticias_controller.dart';
import 'package:dart_dashboard_backend_ont_v1/features/media/controller/resumen.dart';

import '../../../shared/app_strings.dart';
import '../controller/carousel_controller.dart';

void mediaRoutes(String url,Alfred app){
  final carouselController = CarouselController();
  final noiciasController = NoticiasController();
  final resumenController = ResumenController();

  app.delete('${url}carrusel/',carouselController.remove,middleware: []);
  app.get('${url}carrusel/',carouselController.get, middleware: []);//este get recibe un query params name
  app.get('${url}carrusel/list/',carouselController.list,middleware: []);
  app.post('${url}carrusel/upload/',carouselController.upload,middleware: []);


  app.delete('${url}noticias/',noiciasController.remove,middleware: []);
  app.get('${url}noticias/',noiciasController.get, middleware: []);//este get recibe un query params name
  app.get('${url}noticias/list/',noiciasController.list,middleware: []);

  app.delete('${url}resumen/',resumenController.remove,middleware: []);
  app.get('${url}resumen/',resumenController.get, middleware: []);//este get recibe un query params name
  app.get('${url}resumen/list/',resumenController.list,middleware: []);


  app.get('sections/',(req, res) {
    final List<String> Sections =[
      AppStrings.carrusel,
      AppStrings.organismos,
      AppStrings.gobernacion,
      AppStrings.alcaldias,
      AppStrings.programacionFinanciera,
      AppStrings.resumenGestion,
      AppStrings.noticias
    ];
    return {
      "sections":Sections
    };
  });
}