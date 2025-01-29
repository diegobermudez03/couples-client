import 'package:couples_client_app/shared/global_variables/tokens_management.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl;
  String? accessToken;
  final TokensManagement _token;

  HttpClient(this.baseUrl, this._token);


  /*Future<http.Response> _sendRequest(http.Request request) async {
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Si el token expiró, intenta renovarlo
    if (response.statusCode == 401 && refreshToken != null) {
      final newToken = await _refreshAccessToken();

      if (newToken != null) {
        accessToken = newToken;

        // Reintenta la solicitud con el nuevo token
        request.headers['Authorization'] = 'Bearer $accessToken';
        final retryStreamedResponse = await request.send();
        return http.Response.fromStream(retryStreamedResponse);
      }
    }

    // Devuelve la respuesta original o la de reintento
    return response;
  }

   Future<String?> _refreshAccessToken() async {
    // Lógica para renovar el token
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      body: jsonEncode({'refreshToken': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['accessToken'];
    }

    return null;
   }*/
}