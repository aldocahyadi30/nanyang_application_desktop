import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/employee.dart';
import 'package:nanyang_application_desktop/service/employee_service.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeService _employeeService;
  int workerCount = 0;
  int laborCount = 0;
  List<EmployeeModel> _employee = [];
  EmployeeModel _selectedEmployee = EmployeeModel.empty();
  int currentPage = 0;
  int _filterType = 0;

  EmployeeViewModel({required EmployeeService employeeService}) : _employeeService = employeeService;

  get employee => _employee;

  get filteredEmployee {
    if (_filterType == 0) {
      return _employee;
    } else if (_filterType == 1) {
      return _employee.where((element) => element.position.type == 1).toList();
    } else {
      return _employee.where((element) => element.position.type == 2).toList();
    }
  }

  EmployeeModel get selectedEmployee => _selectedEmployee;

  int get currentPageIndex => currentPage;

  int get filterType => _filterType;

  set selectedEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  set currentPageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  set filterType(int type) {
    _filterType = type;
    notifyListeners();
  }

  Future<void> getEmployee() async {
    try {
      List<Map<String, dynamic>> data = await _employeeService.getEmployee();

      _employee = EmployeeModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Get error: ${e.message}');
      } else {
        debugPrint('Employee Get error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> getCount() async {
    try {
      List<int> countData = await _employeeService.getEmployeeCount();

      workerCount = countData[0];
      laborCount = countData[1];
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Count error: ${e.message}');
      } else {
        debugPrint('Employee Count error: ${e.toString()}');
      }
    }
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
  }

  Future<void> store(EmployeeModel model) async {
    try {
      await _employeeService.store(model);
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Berhasil menambahkan karyawan!'), backgroundColor: Colors.green));
      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Store error: ${e.message}');
      } else {
        debugPrint('Employee Store error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> update(EmployeeModel model) async {
    try {
      await _employeeService.update(model);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Data karyawan berhasil diperbarui!'), backgroundColor: Colors.green));
      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Update error: ${e.message}');
      } else {
        debugPrint('Employee Update error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> delete(int id) async {
    try {
      await _employeeService.delete(id);
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Karyawan berhasil dihapus!'), backgroundColor: Colors.green));
      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Delete error: ${e.message}');
      } else {
        debugPrint('Employee Delete error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> index() async {
    currentPageIndex = 0;
    _filterType = 0;
    navigatorKey.currentContext!.read<DashboardViewmodel>().title = 'Karyawan';
    await getEmployee();
  }

  Future<void> create() async {
    currentPageIndex = 1;
    selectedEmployee = EmployeeModel.empty();
    await navigatorKey.currentContext!.read<ConfigurationViewModel>().getPosition();
  }

  Future<void> edit(EmployeeModel model) async {
    currentPageIndex = 1;
    selectedEmployee = model;
    await navigatorKey.currentContext!.read<ConfigurationViewModel>().getPosition();
  }

  void detail(EmployeeModel model) {
    currentPageIndex = 2;
    selectedEmployee = model;
  }
}