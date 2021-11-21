import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {
  HttpClientSpy() {
    when(() => request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenAnswer((_) async {});
  }
}

void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    url = Faker().internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: Faker().internet.email(),
      password: Faker().internet.password(),
    );
  });

  test("Should call HttpClient with correct URL, method and body ", () async {
    final body = {"email": params.email, "password": params.password};
    await sut.auth(params);
    verify(() => httpClient.request(url: url, method: 'post', body: body));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(() => httpClient.request(
          url: any(named: "url"),
          method: any(named: "method"),
          body: any(named: 'body'),
        )).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 401', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
