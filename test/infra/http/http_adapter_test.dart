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
  }) async {
    final uri = Uri.parse(url);
    _client.post(uri);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    late HttpAdapter sut;
    late ClientSpy client;
    late String url;

    setUp(() {
      client = ClientSpy();
      sut = HttpAdapter(client);
      url = Faker().internet.httpUrl();
    });
    test("Should call post with correct values", () async {
      when(() => client.post(Uri.parse(url)))
          .thenAnswer((_) async => Response("{}", 200));

      sut.request(url: url, method: 'post');

      verify(() => client.post(Uri.parse(url)));
    });
  });
}
