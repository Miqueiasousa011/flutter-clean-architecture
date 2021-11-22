import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http_error.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart';

import 'package:fordev/infra/http/http.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    mockPost(200);
  }

  When _mockPostCall() => when(() => this
      .post(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      _mockPostCall().thenAnswer((_) async => Response(body, statusCode));

  void mockPostError(HttpError error) => _mockPostCall().thenThrow(error);
}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = Faker().internet.httpUrl();
    client.mockPost(200);
  });

  group('shared', () {
    test('Should serverError if invalid method is provider', () {
      final future = sut.request(url: url, method: 'invalid');

      expect(future, throwsA(HttpError.serverError));
    });
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

    test('Should return data if post returns 200', () async {
      final body = {'any': 'any'};
      client.mockPost(200, body: jsonEncode(body));
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(body));
    });

    test('Should return null if post returns 200 without data', () async {
      client.mockPost(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(null));
    });

    test('Should return null if post returns 204', () async {
      client.mockPost(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, equals(null));
    });

    test('Should throw BadRequest if HttpAdapter returns 400', () async {
      client.mockPost(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should throw Unauthorized if HttpAdapter returns 401', () async {
      client.mockPost(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should throws ForbiddenError if HttpAdapter returns 403', () {
      client.mockPost(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should throw NotFound if HttpAdapter returns 404', () async {
      client.mockPost(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should throws ServerErrorError if HttpAdapter returns 500', () {
      client.mockPost(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
