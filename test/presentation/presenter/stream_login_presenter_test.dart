import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {
  ValidationSpy() {
    when(() => validate(field: any(named: 'field'), value: any(named: 'value')))
        .thenReturn(null);
  }
}

class AuthenticationSpy extends Mock implements Authentication {
  AuthenticationSpy() {
    when(() => auth(any())).thenAnswer(
        (_) async => AccountEntity(Faker().guid.guid(), Faker().person.name()));
  }
}

void main() {
  late StreamLoginPresenter sut;
  late Authentication authentication;
  late Validation validation;
  late String email;
  late String password;

  setUpAll(() {
    registerFallbackValue(AuthenticationParams(
        email: Faker().internet.email(),
        password: Faker().internet.password()));
  });

  setUp(() {
    authentication = AuthenticationSpy();
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation, authentication);
    password = Faker().internet.password();
    email = Faker().internet.email();
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    when(() => validation.validate(
        field: any(named: 'field'),
        value: any(named: 'value'))).thenReturn('error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, equals('error'))));
    sut.isFormValidStream
        .listen(expectAsync1((error) => expect(error, equals(false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validate ', () {
    when(() => validation.validate(field: 'email', value: any(named: 'value')))
        .thenReturn(null);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, equals(null))));
    sut.isFormValidStream
        .listen(expectAsync1((valide) => expect(valide, equals(false))));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should call validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password));
  });

  test('Should emit passwordError if validation fails', () {
    when(() =>
            validation.validate(field: 'password', value: any(named: 'value')))
        .thenReturn('error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, equals('error'))));
    sut.isFormValidStream
        .listen(expectAsync1((valide) => expect(valide, equals(false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validate', () {
    when(() =>
            validation.validate(field: 'password', value: any(named: 'value')))
        .thenReturn(null);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, equals(null))));
    sut.isFormValidStream
        .listen(expectAsync1((valide) => expect(valide, equals(false))));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error', () async {
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, equals(null))));

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, equals(null))));

    //Ao preencher primeiro o campo de email o formulário está inválido.
    //Ao preencher o campo password, o formulário está válido.
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(const Duration(seconds: 0));
    sut.validatePassword(password);
  });

  test("Should call Authentication with correct params", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, password: password)));
  });

  test("Should emit correct events on Authentication success", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test("Should emit correct events on InvalidCredentialsError", () async {
    when(() => authentication.auth(any()))
        .thenThrow(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(expectAsync1(
        (error) => expect(error, equals('Credenciais inválidas.'))));

    await sut.auth();
  });

  test("Should emit correct events on UnexpectedError", () async {
    when(() => authentication.auth(any())).thenThrow(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo Errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });
}
