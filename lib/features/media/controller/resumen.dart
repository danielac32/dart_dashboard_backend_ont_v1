


import 'dart:io';

import 'package:alfred/alfred.dart';

class ResumenController{
  ResumenController();

  Future<Map<String, dynamic>> remove(HttpRequest request, HttpResponse response) async {

    final name = request.uri.queryParameters['name'];

    if (name == null || name.isEmpty) {
      throw AlfredException(400, 'Parameter "name" is required');
    }

    try {
      final imageFile = File('assets/resumen/$name');

      // Verificar si el archivo existe
      if (!await imageFile.exists()) {
        throw AlfredException(404, 'Image not found');
      }

      // Eliminar el archivo
      await imageFile.delete();

      // Respuesta exitosa
      return {'success': true, 'message': 'Image deleted successfully'};

    } on AlfredException {
      rethrow; // Re-lanza las excepciones de Alfred
    } catch (e) {
      throw AlfredException(500, 'Error deleting image: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> list(HttpRequest request, HttpResponse response) async {
    try {
      final directory = Directory('assets/resumen');

      // Verificar si el directorio existe
      if (!await directory.exists()) {
        throw AlfredException(404, 'resumen directory not found');
      }

      // Listar archivos y filtrar solo los de imagen
      final files = await directory.list()
          .where((file) => file is File)
          .map((file) => (file as File).path.split('/').last)
          .where((filename) => _isImageFile(filename))
          .toList();

      return {
        "success": true,
        "count": files.length,
        "list": files,
        "timestamp": DateTime.now().toIso8601String()
      };
    } catch (e) {
      throw AlfredException(500, 'Error listing images: ${e.toString()}');
    }
  }

// Helper para verificar extensiones de imagen
  static bool _isImageFile(String filename) {
    final imageExtensions = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'svg'];
    final extension = filename.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }


  Future<Stream<List<int>>> get(HttpRequest request, HttpResponse response) async {

    final name = request.uri.queryParameters['name'];
    try {
      final imageFile = File('assets/resumen/$name');

      if (!await imageFile.exists()) {
        throw AlfredException(404, 'Image not found');
      }

      // Obtener la extensión del archivo
      final extension = name?.split('.').last.toLowerCase();

      // Mapear extensiones a tipos de contenido
      final contentTypeMap = {
        'png': ContentType('image', 'png'),
        'jpg': ContentType('image', 'jpeg'),
        'jpeg': ContentType('image', 'jpeg'),
        'gif': ContentType('image', 'gif'),
        'webp': ContentType('image', 'webp'),
        'svg': ContentType('image', 'svg+xml'),
      };
      // Obtener el contentType o usar uno por defecto (png)
      final contentType = contentTypeMap[extension] ?? ContentType('image', 'png');
      response.headers.contentType = contentType;
      return imageFile.openRead();
    } catch (e) {
      throw AlfredException(500, 'Error loading image');
    }
  }
}