abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);

  Stream<String?> get emailErrorStream;
}
