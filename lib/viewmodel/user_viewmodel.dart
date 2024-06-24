import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/service/user_service.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;
  List<UserModel> _user = [];
  UserModel  _selectedUser = UserModel.empty();
  int currentPage = 0;

  UserViewModel({required UserService userService}) : _userService = userService;

  get user => _user;
  UserModel get selectedUser => _selectedUser;
  int get currentPageIndex => currentPage;

  set selectedUser(UserModel user) {
    _selectedUser = user;
    notifyListeners();
  }

  set currentPageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<UserModel> getUserByID(String id) async {
    try {
      Map<String, dynamic> data = await _userService.getUserByID(id);

      return UserModel.fromSupabase(data);
    } catch (e) {
      UserModel user = UserModel.empty();
      if (e is PostgrestException) {
        debugPrint('User error: ${e.message}');
      } else {
        debugPrint('User error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
      return user;
    }
  }

  Future<void> getUser() async {
    try {
      List<Map<String, dynamic>> data = await _userService.getUser();
      _user = UserModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('User error: ${e.message}');
      } else {
        debugPrint('User error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> index() async{
    currentPageIndex = 0;
    await getUser();
  }

  Future<void> create ()async{
    currentPageIndex = 1;
    selectedUser = UserModel.empty();
    await navigatorKey.currentContext!.read<EmployeeViewModel>().getEmployee();
  }

  Future<void> edit(UserModel model) async{
    currentPageIndex = 1;
    selectedUser = model;
    await navigatorKey.currentContext!.read<EmployeeViewModel>().getEmployee();

  }


  void detail(UserModel model){
    currentPageIndex = 2;
    selectedUser = model;
  }
}