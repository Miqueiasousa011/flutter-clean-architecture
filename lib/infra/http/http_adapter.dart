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

    Response response = Response('', 500);

    try {
      if (method == 'post') {
        response = await _client.post(
          uri,
          headers: _headers,
          body: jsonBody,
        );
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map<String, String> get _headers =>
      {'content-type': 'application/json', 'accept': 'application/json'};

  Map? _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else if (response.statusCode == 500) {
      throw HttpError.serverError;
    }
  }
}
