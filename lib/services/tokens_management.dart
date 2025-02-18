import 'package:couples_client_app/services/secure_storage/secure_storage_service.dart';

class TokensManagement {
  String? _refreshToken;
  String? _accessToken;
  final SecureStorageService _storage;

  TokensManagement(this._storage);

  void setRefreshToken(String token){
    _storage.writeValue(refreshTokenKey, token);
    _refreshToken = token;
  }

  void deleteRefreshToken(){
    _storage.deleteValue(refreshTokenKey);
    _refreshToken = null;
  }

  Future<String?> getRefreshToken() async{
    if(_refreshToken == null){
      final token = await _storage.readValue(refreshTokenKey);
      _refreshToken = token;
    }
    return _refreshToken;
  }

  void setAccessToken(String token){
    _accessToken = token;
  }
  
  String? getAccessToken() => _accessToken;
}