import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

class HttpAdapter {
  final Client _client;

  HttpAdapter(this._client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final uri = Uri.parse(url);
    final jsonBody = body != null ? jsonEncode(body) : null;

    _client.post(uri, headers: _headers, body: jsonBody);
  }

  Map<String, String> get _headers =>
      {'content-type': 'application/json', 'accept': 'application/json'};
}

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = Faker().internet.httpUrl();

    when(() => client.post(Uri.parse(url),
        headers: any(named: 'headers'),
        body: any(named: 'body'))).thenAnswer((_) async => Response("{}", 200));
  });
  group('post', () {
    test("Should call post with correct values", () async {
      final headers = {
        'content-type': 'application/json',
        'accept': 'application/json'
      };
      final body = {'any': 'any'};

      sut.request(url: url, method: 'post', body: body);

      verify(() => client.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          ));
    });

    test("Should call post without body", () async {
      sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url), headers: any(named: 'headers')));
    });
  });
}
