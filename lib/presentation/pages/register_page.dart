import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../logic/auth/auth_bloc.dart';
import '../../../logic/auth/auth_event.dart';
import '../../../logic/auth/auth_state.dart';
import '../../../data/local/user_dao.dart';
import 'login_page.dart';
import 'home_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(UserDao()),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tài khoản')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Get.offAll(() => const HomePage());
          } else if (state is AuthError) {
            Get.snackbar('Lỗi', state.message);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                ),
                const SizedBox(height: 20),
                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final username = _usernameCtrl.text.trim();
                          final password = _passwordCtrl.text.trim();
                          if (username.isEmpty || password.isEmpty) {
                            Get.snackbar(
                              'Lỗi',
                              'Vui lòng nhập đầy đủ thông tin',
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                            RegisterRequested(username, password),
                          );
                        },
                        child: const Text('Đăng ký'),
                      ),
                TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: const Text('Đã có tài khoản? Đăng nhập'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
