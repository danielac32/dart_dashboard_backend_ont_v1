
import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/controllers/controller.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import '../middlewares/checkLogin.dart';
import '../middlewares/checkRegister.dart';

void authRoutes(String url,Alfred app,UserService userService){
  final authController= AuthController(userService);
  app.post("${url}register", authController.register,middleware: [validateRegisterMiddleware,checkPassWordLengthMiddleware]);
  app.post("${url}login", authController.login,middleware: [validateLoginMiddleware]);
}

void userRoutes(String url,Alfred app,UserService userService){
  final authController= AuthController(userService);
  app.get(url, authController.list,middleware: []);
}