part of repository;

class AuthRepository {
  final TokenHelper _tokenHelper;

  AuthRepository(this._tokenHelper);
  // data source obj

  Future<bool> get isLoggedIn => _tokenHelper.isLoggedIn;

  Future setToken(String token)async{
    await _tokenHelper.saveAuthToken(token);
  }

  Future logout()async{
    await _tokenHelper.removeAuthToken();
  }
}
