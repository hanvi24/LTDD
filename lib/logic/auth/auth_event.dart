abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  LoginRequested(this.username, this.password);
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  RegisterRequested(this.username, this.password);
}

class LogoutRequested extends AuthEvent {}
