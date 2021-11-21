import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';

import 'package:fordev/domain/usecases/usecases.dart';

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

  test("Should call HttpClient with correct URL, method and body ", () async {
    final body = {
      "email": params.email,
      "password": params.password,
    };

    when(() => httpClient.request(
        url: any(named: 'url'),
        method: 'post',
        body: any(named: 'body'))).thenAnswer((_) async {});

    await sut.auth(params);

    verify(() => httpClient.request(url: url, method: 'post', body: body));
  });
}
