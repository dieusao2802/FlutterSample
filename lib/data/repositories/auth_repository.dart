class AuthRepository {
  AuthRepository();

  Future<dynamic> login(String email, String password) async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == "test@gmail.com" && password == "123456") {
      return {'token': 'fake_token_123', 'user': {'name': 'User Test'}};
    } else {
      throw Exception("Invalid credentials");
    }
  }
}
