

class DynamicRequest {
  final Map<String, dynamic> _data;

  // Constructor que recibe un Map<String, dynamic>
  DynamicRequest(this._data);

  // Método para obtener un valor por su clave
  dynamic operator [](String key) => _data[key];

  // Método para establecer un valor por su clave
  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }

  // Método para verificar si una clave existe
  bool containsKey(String key) => _data.containsKey(key);

  // Método para convertir la clase de vuelta a un Map<String, dynamic>
  Map<String, dynamic> toMap() => _data;

  // Método dinámico para acceder a los valores como si fueran métodos
  dynamic call(String methodName) {
    if (_data.containsKey(methodName)) {
      return _data[methodName];
    } else {
      return null;
      // throw ArgumentError('El método "$methodName" no existe en los datos proporcionados.');
    }
  }

  // Método para validar que ciertos campos requeridos estén presentes
  bool validate(List<String> requiredFields) {
    for (var field in requiredFields) {
      if (!_data.containsKey(field) || _data[field] == null || _data[field].toString().isEmpty) {
        throw ArgumentError('El campo "$field" es obligatorio.');
      }
    }
    return true;
  }
}