
import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/controllers/controller.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import '../../../middlewares/authMiddleware.dart';
import '../middlewares/checkGetId.dart';
import '../middlewares/checkLogin.dart';
import '../middlewares/checkRegister.dart';
import '../middlewares/checkUpdate.dart';

void authRoutes(String url,Alfred app,UserService userService){
  final authController= AuthController(userService);
  app.post("${url}register", authController.register,middleware: [/*authMiddleware,*/validateRegisterMiddleware,checkPassWordLengthMiddleware]);
  app.post("${url}login", authController.login,middleware: [validateLoginMiddleware]);
}

void userRoutes(String url,Alfred app,UserService userService){
  final authController= AuthController(userService);
  app.get("get", authController.list,middleware: []);//GET ALL
  app.get(url, authController.list,middleware: [authMiddleware]);//GET ALL
  app.get("$url:id", authController.getById,middleware: [authMiddleware,validateGetIdMiddleware,]);//GET ID
  app.patch("$url:id", authController.updateById,middleware: [authMiddleware,validateGetIdMiddleware,validateUpdateMiddleware]);//UPDATE
  app.delete("$url:id", authController.deleteById,middleware: [authMiddleware,validateGetIdMiddleware]);//delete
}
/*
{
"password":"1234567",
"email": "daniel@gmail.com",
"name":"daniel quintero",
"department":"dgtic",
  "role":"admin"


}
 */