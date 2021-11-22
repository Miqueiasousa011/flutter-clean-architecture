import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart';

import 'package:fordev/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  When mockRequest() => when(() => client.post(Uri.parse(url),
      headers: any(named: 'headers'), body: any(named: 'body')));

  void mockResponse(String response, int statusCod) =>
      mockRequest().thenAnswer((_) async => Response(response, 200));

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = Faker().internet.httpUrl();
  });
  group('post', () {
    setUp(() {
      mockResponse('', 200);
    });
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

    test('Should return data if post returns 200', () async {
      final body = {'any': 'any'};
      mockResponse(jsonEncode(body), 200);
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(body));
    });

    test('Should return null if post returns 200 without data', () async {
      mockResponse('', 200);
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(null));
    });

    test('Should return null if post returns 204', () async {
      mockResponse('', 204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(null));
    });
  });
}
