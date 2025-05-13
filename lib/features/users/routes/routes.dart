
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/controllers/controller.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import '../../../middlewares/authMiddleware.dart';
import '../middlewares/checkAddNoticia.dart';
import '../middlewares/checkAddOrganismo.dart';
import '../middlewares/checkAddPermission.dart';
import '../middlewares/checkAddResumen.dart';
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
  // Endpoints básicos para User
  app.get('/avatar',(req, res) async {
    try {
      // Lee la imagen del sistema de archivos
      final imageFile = File('assets/avatar/image.png');

      if (!await imageFile.exists()) {
    throw AlfredException(404, 'Image not found');
    }
    // Configura los headers adecuados para imágenes
    res.headers.contentType = ContentType('image', 'png'); // Ajusta según el tipo de imagen
    return imageFile.openRead();
    } catch (e) {
    throw AlfredException(500, 'Error loading image');
    }
  });
  //app.get("$url/paginated",authController.getPaginator,middleware: []);
  app.get("get", authController.list,middleware: []);//GET ALL
  app.get(url, authController.list,middleware: [authMiddleware]);//GET ALL
  app.get("${url}filter", authController.listFilter,middleware: [authMiddleware]);//GET ALL
  app.get("$url:id", authController.getById,middleware: [authMiddleware,validateGetIdMiddleware,]);//GET ID
  app.patch("$url:id", authController.updateById,middleware: [authMiddleware,validateGetIdMiddleware,validateUpdateMiddleware]);//UPDATE
  app.delete("$url:id", authController.deleteById,middleware: [authMiddleware,validateGetIdMiddleware]);//delete

  /***********************************************************************************************************/
  // Endpoints para manejar permisos
  app.get("$url:id/permissions", authController.getPermissionsByUser, middleware: [/*authMiddleware,*/ validateGetIdMiddleware]); // GET PERMISSIONS BY USER
  app.post("$url:id/permissions", authController.addPermissionToUser, middleware: [/*authMiddleware,*/ validateGetIdMiddleware, validateAddPermissionMiddleware]); // ADD PERMISSION TO USER
  app.delete("$url:id/permissions/:permissionId", authController.removePermissionFromUser, middleware: [/*authMiddleware, */validateGetIdMiddleware/*, validateRemovePermissionMiddleware*/]); // REMOVE PERMISSION FROM USER

  // Endpoints para manejar organismos de gobernación
  app.get("$url:id/organismos", authController.getOrganismosByUser, middleware: [/*authMiddleware,*/ validateGetIdMiddleware]); // GET ORGANISMOS BY USER
  app.post("$url:id/organismos", authController.addOrganismoToUser, middleware: [/*authMiddleware, */validateGetIdMiddleware, validateAddOrganismoMiddleware]); // ADD ORGANISMO TO USER
  app.delete("$url:id/organismos/:organismoId", authController.removeOrganismoFromUser, middleware: [authMiddleware, validateGetIdMiddleware]); // REMOVE ORGANISMO FROM USER


  // Endpoints para manejar programaciones financieras
  /*app.get("$url:id/programaciones", authController.getProgramacionesByUser, middleware: [authMiddleware, validateGetIdMiddleware]); // GET PROGRAMACIONES BY USER
  app.post("$url:id/programaciones", authController.addProgramacionToUser, middleware: [authMiddleware, validateGetIdMiddleware, validateAddProgramacionMiddleware]); // ADD PROGRAMACION TO USER
  app.delete("$url:id/programaciones/:programacionId", authController.removeProgramacionFromUser, middleware: [authMiddleware, validateGetIdMiddleware, validateRemoveProgramacionMiddleware]); // REMOVE PROGRAMACION FROM USER
*/
  // Endpoints para manejar resúmenes de gestión
  app.get("$url:id/resumen", authController.getResumenesByUser, middleware: [/*authMiddleware, */validateGetIdMiddleware]); // GET RESUMENES BY USER
  app.post("$url:id/resumen", authController.addResumenToUser, middleware: [/*authMiddleware, */validateGetIdMiddleware, validateAddResumenMiddleware]); // ADD RESUMEN TO USER
  app.delete("$url:id/resumen/:resumenId", authController.removeResumenFromUser, middleware: [/*authMiddleware,*/ validateGetIdMiddleware]); // REMOVE RESUMEN FROM USER

  // Endpoints para manejar noticias
  app.get("$url:id/noticias", authController.getNoticiasByUser, middleware: [/*authMiddleware, */validateGetIdMiddleware]); // GET NOTICIAS BY USER
  app.post("$url:id/noticias", authController.addNoticiaToUser, middleware: [/*authMiddleware,*/ validateGetIdMiddleware, validateAddNoticiaMiddleware]); // ADD NOTICIA TO USER
  app.delete("$url:id/noticias/:noticiaId", authController.removeNoticiaFromUser, middleware: [/*authMiddleware, */validateGetIdMiddleware]); // REMOVE NOTICIA FROM USER

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