import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/auth/screen/login_screen.dart';
import 'package:nanyang_application_desktop/module/home_screen.dart';
import 'package:nanyang_application_desktop/service/auth_service.dart';
import 'package:nanyang_application_desktop/service/navigation_service.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  UserModel _user = UserModel.empty();

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }

  AuthViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<void> login(String email, String password) async {
    try {
      final bool status = await _authenticationService.login(email, password);

      if (status) {
        await initialize();

        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Login berhasil'), backgroundColor: Colors.green));
        navigatorKey.currentContext!.read<NavigationService>().navigateToReplace(const HomeScreen());
      }
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Auth error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Akun tidak ditemukan!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Auth error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Auth error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  //register
  Future<void> register(String email, String password, int employeeID, int level) async {
    try {
      await _authenticationService.register(email, password, employeeID, level);

      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Registrasi berhasil'), backgroundColor: Colors.green));
      await navigatorKey.currentContext!.read<UserViewModel>().index();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Register error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Register error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Register error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> update(String uid, String email, int employeeID, int level) async {
    try {
      await _authenticationService.update(uid, email, employeeID, level);

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Data user berhasil diperbaharui!!'), backgroundColor: Colors.green));
      await navigatorKey.currentContext!.read<UserViewModel>().index();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Update error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Gagal memperbarui data user!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Update error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Update error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> delete(String uid) async {
    try {
      await _authenticationService.delete(uid);

      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('User berhasil dihapus'), backgroundColor: Colors.green));
      await navigatorKey.currentContext!.read<UserViewModel>().index();
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Delete error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Gagal menghapus user!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Delete error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Delete error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _authenticationService.logout();
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Logout berhasil!!'), backgroundColor: Colors.green));
      navigatorKey.currentContext!.read<NavigationService>().navigateToReplace(const LoginScreen());
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Logout error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Logout gagal!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Logout error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Logout error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> getUser() async {
    try {
      user = await navigatorKey.currentContext!.read<UserViewModel>().getUserByID(Supabase.instance.client.auth.currentUser!.id);
    } catch (e) {
      if (e is AuthException) {
        debugPrint('Get user error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Gagal mendapatkan data user!'), backgroundColor: Colors.red));
      } else if (e is PostgrestException) {
        debugPrint('Logout error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Logout error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> initialize() async {
    try {
      await getUser();
      await navigatorKey.currentContext!.read<ConfigurationViewModel>().initialize();
      await navigatorKey.currentContext!.read<EmployeeViewModel>().getCount();
      await navigatorKey.currentContext!.read<AttendanceViewModel>().getCount();
      await navigatorKey.currentContext!.read<RequestViewModel>().getRequest();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Initialize error: ${e.message}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      } else {
        debugPrint('Initialize error: ${e.toString()}');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      }
    }
  }
}