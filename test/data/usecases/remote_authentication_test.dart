import 'package:faker/faker.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

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

  When mockRequest() => when(() => httpClient.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body')));

  void mockHttpData({Map? json}) {
    final body = json ??
        {
          'accessToken': Faker().guid.guid(),
          'name': Faker().person.name(),
        };
    mockRequest().thenAnswer((_) async => body);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  test("Should call HttpClient with correct URL, method and body ", () async {
    mockHttpData();

    await sut.auth(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {"email": params.email, "password": params.password},
        ));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient retuns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return an AccountEntity if HttpClient returns 200', () async {
    final account = {
      'accessToken': Faker().guid.guid(),
      'name': Faker().person.name()
    };

    mockHttpData(json: account);

    final response = await sut.auth(params);

    expect(response.token, equals(account['accessToken']));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    final accountError = {
      'any_token': Faker().guid.guid(),
      'any_name': Faker().person.name()
    };

    mockHttpData(json: accountError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
