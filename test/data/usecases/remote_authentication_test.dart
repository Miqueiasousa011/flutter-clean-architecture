import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;

  setUp(() {
    url = Faker().internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpClient with correct URL, method", () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: 'post',
        )).thenAnswer((_) async {});

    await sut.auth();

    verify(() => httpClient.request(url: url, method: 'post'));
  });
}
