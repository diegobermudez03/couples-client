import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const refreshTokenKey = "refresh_token";

abstract class SecureStorageService{
  Future<String?> readValue(String key);
  Future<void> writeValue(String key, String value);
}


class SecureStorageServImpl implements SecureStorageService{
  final FlutterSecureStorage storage;
  SecureStorageServImpl(): storage = const FlutterSecureStorage();

  @override
  Future<String?> readValue(String key) async{
    return await storage.read(key: key);
  } 

  @override
  Future<void> writeValue(String key, String value) async{
    await storage.write(key: key, value: value);
  }
}


class SecureStorageMock implements SecureStorageService{
   @override
  Future<String?> readValue(String key) async{
    return '6WTFV75gY1tb-sXpTzXtLgMJQZObEYa1-0e-57Gn04c=';
  }

  @override
  Future<void> writeValue(String key, String value) async{
  }
}