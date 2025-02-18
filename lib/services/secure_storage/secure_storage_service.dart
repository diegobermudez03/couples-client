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
    try{
      return await storage.read(key: key);
    }catch(error){
      return null;
    }
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
    return '0OuPHKZLcG9nhm3JAdxqpGmjtMSVrTEPNNYFi2F3nTk=';
  }

  @override
  Future<void> writeValue(String key, String value) async{
  }
  
  @override
  Future<void> deleteValue(String key) async{
  }
}