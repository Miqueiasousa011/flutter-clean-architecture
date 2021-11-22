import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client _client;

  HttpAdapter(this._client);

  @override
  Future<Map?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final uri = Uri.parse(url);
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await _client.post(uri, headers: _headers, body: jsonBody);

    return _handleResponse(response);
  }

  Map<String, String> get _headers =>
      {'content-type': 'application/json', 'accept': 'application/json'};

  Map? _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw HttpError.badRequest;
    }
  }
}
