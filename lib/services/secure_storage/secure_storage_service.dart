import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const refreshTokenKey = "refresh_token";

abstract class SecureStorageService{
  Future<String?> readValue(String key);
  Future<void> writeValue(String key, String value);
  Future<void> deleteValue(String key);
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
  
  @override
  Future<void> deleteValue(String key) async{
    await storage.delete(key: key);
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
  
  @override
  Future<void> deleteValue(String key) async{
  }
}