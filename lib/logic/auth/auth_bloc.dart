import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/local/user_dao.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserDao userDao;

  AuthBloc(this.userDao) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await userDao.getUser(event.username, event.password);
    if (user != null) {
      emit(AuthAuthenticated(event.username));
    } else {
      emit(AuthError('Tên đăng nhập hoặc mật khẩu không đúng'));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final exists = await userDao.usernameExists(event.username);
    if (exists) {
      emit(AuthError('Tên đăng nhập đã tồn tại'));
      return;
    }
    await userDao.insertUser(event.username, event.password);
    emit(AuthAuthenticated(event.username));
  }

  void _onLogout(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthLoggedOut());
  }
}
