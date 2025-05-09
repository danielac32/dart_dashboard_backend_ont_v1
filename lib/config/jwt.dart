
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';



String generateJWT(String email) {
  final secretKey = 'tu_clave_secreta_muy_segura';
  final jwt = JWT({
    'email': email,
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
  });
  return jwt.sign(SecretKey(secretKey));
}

// Función para validar un token JWT
bool validateJWT(String token) {
  try {
    final secretKey = 'tu_clave_secreta_muy_segura';
    JWT.verify(token, SecretKey(secretKey));
    return true;
  } catch (e) {
    return false;
  }
}