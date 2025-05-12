

import 'dart:async';
import 'package:alfred/alfred.dart';
import '../interfaces/update_request.dart';


FutureOr validateAddPermissionMiddleware(HttpRequest req, HttpResponse res) async {
  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  dynamicRequest.validate(['section', 'canCreate', 'canEdit','canDelete','canPublish']);
}


