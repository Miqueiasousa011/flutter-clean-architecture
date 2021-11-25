abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void dispose();

  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValid;
  Stream<bool> get isLoadingController;
  Stream<String?> get mainErrorController;
}
