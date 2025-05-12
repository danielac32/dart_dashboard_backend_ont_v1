


import 'dart:async';

import 'package:alfred/alfred.dart';

import '../../../features/users/interfaces/update_request.dart';


FutureOr validateUpdateDCRMiddleware(HttpRequest req, HttpResponse res) async {
  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  dynamicRequest.validate(['name']);
}


