


import 'package:alfred/alfred.dart';

import '../controller/dcr_controller.dart';
import '../middleware/checkFields.dart';
import '../middleware/checkId.dart';
import '../services/dcr_services.dart';


void direccionRoutes(String url,Alfred app,DireccionService direccionService){
  final dirController= DireccionController(direccionService);
  app.post(url, dirController.create,middleware: [validateUpdateDCRMiddleware]);//CREATE
  app.get(url, dirController.list,middleware: []);//GET ALL
  app.get("$url:id", dirController.getById,middleware: [validateIdMiddleware]);//GET ID
  app.patch("$url:id", dirController.updateById,middleware: [validateIdMiddleware,validateUpdateDCRMiddleware]);//UPDATE
  app.delete("$url:id", dirController.deleteById,middleware: [validateIdMiddleware]);//delete
}

void cargoRoutes(String url,Alfred app , CargoService cargoService){
  final cargoController= CargoController(cargoService);
  app.post(url, cargoController.create,middleware: [validateUpdateDCRMiddleware]);//CREATE
  app.get(url, cargoController.list,middleware: []);//GET ALL
  app.get("$url:id", cargoController.getById,middleware: []);//GET ID
  app.patch("$url:id", cargoController.updateById,middleware: []);//UPDATE
  app.delete("$url:id", cargoController.deleteById,middleware: []);//delete
}

void rolRoutes(String url,Alfred app,RoleService roleService){
  final roleController= RoleController(roleService);
  app.post(url, roleController.create,middleware: [validateUpdateDCRMiddleware]);//CREATE
  app.get(url, roleController.list,middleware: []);//GET ALL
  app.get("$url:id", roleController.getById,middleware: [validateIdMiddleware]);//GET ID
  app.patch("$url:id", roleController.updateById,middleware: [validateIdMiddleware,validateUpdateDCRMiddleware]);//UPDATE
  app.delete("$url:id", roleController.deleteById,middleware: [validateIdMiddleware]);//delete
}