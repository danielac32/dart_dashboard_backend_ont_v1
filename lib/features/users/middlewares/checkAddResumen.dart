


import 'dart:async';
import 'package:alfred/alfred.dart';
import '../interfaces/update_request.dart';


FutureOr validateAddResumenMiddleware(HttpRequest req, HttpResponse res) async {
  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  dynamicRequest.validate(['titulo', 'descripcion', 'imagenUrl']);
}
