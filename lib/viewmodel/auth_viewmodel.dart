import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/auth/screen/login_screen.dart';
import 'package:nanyang_application_desktop/module/home_screen.dart';
import 'package:nanyang_application_desktop/provider/configuration_provider.dart';
import 'package:nanyang_application_desktop/provider/toast_provider.dart';
import 'package:nanyang_application_desktop/service/auth_service.dart';
import 'package:nanyang_application_desktop/service/firebase_service.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final userViewModel = Provider.of<UserViewModel>(navigatorKey.currentContext!, listen: false);
  final firebaseService = FirebaseService();

  AuthViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<void> login(String email, String password) async {
    try {
      String? token = await firebaseService.getFCMToken();

      final Map<String, dynamic> user = await _authenticationService.login(email, password, token);

      if (user['id'] != '') {
        navigatorKey.currentContext!.read<ConfigurationProvider>().setUser(UserModel.fromSupabase(user));

        _toastProvider.showToast('Login berhasil!', 'success');
        redirect(const HomeScreen(), true);
      } else {
        return;
      }
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Auth error: ${e.message}');
        _toastProvider.showToast('Akun tidak ditemukan!', 'error');
      } else if (e is PostgrestException) {
        debugPrint('Auth error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Auth error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  //register
  Future<void> register(String email, String password, int employeeID, int level) async {
    try {
      await _authenticationService.register(email, password, employeeID, level);

      _toastProvider.showToast('Registrasi berhasil!', 'success');
      userViewModel.getUser();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Register error: ${e.message}');
        _toastProvider.showToast('Email sudah terdaftar!', 'error');
      } else if (e is PostgrestException) {
        debugPrint('Register error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Register error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> update(String uid, String email, int employeeID, int level) async {
    try {
      await _authenticationService.update(uid, email, employeeID, level);

      _toastProvider.showToast('Data user berhasil diperbarui!', 'success');
      userViewModel.getUser();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Update error: ${e.message}');
        _toastProvider.showToast('Gagal memperbarui data user!', 'error');
      } else if (e is PostgrestException) {
        debugPrint('Update error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Update error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> delete(String uid) async {
    try {
      await _authenticationService.delete(uid);

      _toastProvider.showToast('Data user berhasil dihapus!', 'success');
      userViewModel.getUser();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Delete error: ${e.message}');
        _toastProvider.showToast('Gagal menghapus data user!', 'error');
      } else if (e is PostgrestException) {
        debugPrint('Delete error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Delete error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _authenticationService.logout();
      _toastProvider.showToast('Logout berhasil!', 'success');
      redirect(const LoginScreen(), true);
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Logout error: ${e.message}');
        _toastProvider.showToast('Logout gagal!', 'error');
      } else if (e is PostgrestException) {
        debugPrint('Logout error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Logout error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  void redirect(Widget screen, bool isReplace) {
    if (isReplace) {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    }
  }
}