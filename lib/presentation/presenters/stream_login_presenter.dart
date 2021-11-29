import 'dart:async';

import 'package:fordev/ui/pages/pages.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  String? mainError;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation _validation;
  final Authentication _authentication;

  StreamController<LoginState>? _controller =
      StreamController<LoginState>.broadcast();

  final _state = LoginState();

  StreamLoginPresenter(this._validation, this._authentication);

  @override
  Stream<String?>? get emailErrorStream =>
      _controller?.stream.map((state) => state.emailError).distinct();

  @override
  Stream<String?>? get passwordErrorStream =>
      _controller?.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<bool>? get isFormValidStream =>
      _controller?.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool>? get isLoadingStream =>
      _controller?.stream.map((state) => state.isLoading).distinct();

  @override
  Stream<String?>? get mainErrorStream =>
      _controller?.stream.map((state) => state.mainError).distinct();

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validation.validate(field: 'email', value: email);
    _controller?.add(_state);
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        _validation.validate(field: 'password', value: password);
    _controller?.add(_state);
  }

  @override
  Future<void> auth() async {
    _state.isLoading = true;
    _controller?.add(_state);
    try {
      await _authentication.auth(AuthenticationParams(
          email: _state.email!, password: _state.password!));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    } finally {
      _state.isLoading = false;
      _controller?.add(_state);
    }
  }

  @override
  Future<void> dispose() async {
    await _controller?.close();
    _controller = null;
  }
}
