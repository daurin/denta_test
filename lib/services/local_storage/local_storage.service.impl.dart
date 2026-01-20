import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  late final GetStorage _storage;
  final String _container;

  LocalStorageServiceImpl([this._container = 'defaultContainer']) {
    _storage = GetStorage(_container);
  }

  @override
  void setValue<T>(String key, T value) {
    _storage.write(key, value);
  }

  @override
  T? getValue<T>(String key) {
    return _storage.read<T>(key);
  }

  @override
  void remove(String key) {
    _storage.remove(key);
  }

  @override
  bool containsKey(String key) {
    return _storage.hasData(key);
  }

  @override
  Future<void> clear() async {
    await _storage.erase();
  }

  @override
  String get container => _container;
}
