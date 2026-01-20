abstract class LocalStorageService {
  /// Constructor que requiere el contenedor o namespace
  LocalStorageService([String container = 'default']);

  /// Obtiene el nombre del contenedor actual
  String get container;

  /// Guarda un valor de cualquier tipo soportado (String, int, double, bool, `List<String>)`
  ///
  /// Cambiado a síncrono: la llamada lanzará la escritura en el backend de
  /// almacenamiento pero no devuelve un Future — es un 'fire-and-forget'.
  void setValue<T>(String key, T value);

  /// Obtiene un valor de cualquier tipo soportado
  T? getValue<T>(String key);

  /// Elimina un valor por su key
  void remove(String key);

  /// Verifica si existe una key
  bool containsKey(String key);

  /// Limpia todos los valores almacenados
  Future<void> clear();
}
