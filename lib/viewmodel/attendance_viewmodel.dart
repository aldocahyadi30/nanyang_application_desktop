import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/attendance_admin.dart';
import 'package:nanyang_application_desktop/model/attendance_user.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/service/attendance_service.dart';
import 'package:nanyang_application_desktop/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;
  int _workerCount = 0;
  int _laborCount = 0;
  int _currentPage = 0;
  int _filterType = 0;
  List<AttendanceAdminModel> adminAttendance = [];
  List<AttendanceUserModel> userAttendance = [];
  AttendanceAdminModel _selectedAtt = AttendanceAdminModel.empty();
  DateTime _selectedDateAttAdmin = DateTime.now();
  DateTimeRange _selectedDateUser = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      end: DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)));

  AttendanceViewModel({required AttendanceService attendanceService}) : _attendanceService = attendanceService;

  get attendanceUser => userAttendance;

  get attendanceAdmin => adminAttendance;

  get attendanceWorker => adminAttendance.where((element) => element.employee.position.type == 1).toList();

  get attendanceLabor => adminAttendance.where((element) => element.employee.position.type == 2).toList();

  AttendanceAdminModel get selectedAtt => _selectedAtt;

  get selectedAdminDate => _selectedDateAttAdmin;

  get selectedUserDate => _selectedDateUser;

  int get workerCount => _workerCount;

  int get laborCount => _laborCount;

  int get currentPageIndex => _currentPage;

  int get filterType => _filterType;

  set currentPageIndex(int index) {
    _currentPage = index;
    notifyListeners();
  }

  set setAttendanceAdmin(AttendanceAdminModel model) {
    _selectedAtt = model;
    notifyListeners();
  }

  set setAdminDate(DateTime date) {
    _selectedDateAttAdmin = date;
    notifyListeners();
  }

  set setUserDate(DateTimeRange date) {
    _selectedDateUser = date;
    notifyListeners();
  }

  set workerCount(int count) {
    _workerCount = count;
    notifyListeners();
  }

  set laborCount(int count) {
    _laborCount = count;
    notifyListeners();
  }

  set filterType(int type) {
    _filterType = type;
    notifyListeners();
  }

  Future<void> getAdminAttendance() async {
    try {
      List<Map<String, dynamic>>? data;
      data = await _attendanceService.getAdminAttendanceByDate(parseDateToString(_selectedDateAttAdmin));

      adminAttendance = AttendanceAdminModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Attendance error: ${e.message}');
      } else {
        debugPrint('Get Attendance error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> getUserAttendance() async {
    try {
      UserModel user = navigatorKey.currentContext!.read<AuthViewModel>().user;
      String startDate = parseDateToString(_selectedDateUser.start);
      String endDate = parseDateToString(_selectedDateUser.end);
      int employeeID = user.employee.id;
      List<Map<String, dynamic>> data = await _attendanceService.getUserAttendance(employeeID, startDate, endDate);

      List<DateTime> dateRange = generateDateRange(_selectedDateUser.start, _selectedDateUser.end);

      userAttendance = AttendanceUserModel.fromSupabaseList(data, dateRange);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  List<DateTime> generateDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (currentDate.weekday != DateTime.sunday) {
        dateRange.add(currentDate);
      }
    }
    return dateRange;
  }

  Future<void> getCount() async {
    try {
      List<int> data = await _attendanceService.getAttendanceCount();

      workerCount = data[0];
      laborCount = data[1];
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  String getShortenedName(String name) {
    List<String> nameParts = name.split(' ');

    if (nameParts.length == 1) {
      return nameParts[0];
    } else if (nameParts.length == 2) {
      return nameParts.join(' ');
    } else {
      return nameParts.take(2).join(' ') + nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }
  }

  String getAvatarInitials(String name) {
    List<String> nameParts = name.split(' ');

    return ((nameParts.isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();
  }

  Future<void> storeWorker(AttendanceAdminModel model) async {
    try {
      await _attendanceService.storeWorkerAttendance(model);

      await getAdminAttendance();
      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Worker error: ${e.message}');
      } else {
        debugPrint('Store Attendance Worker error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> storeLabor(AttendanceAdminModel model) async {
    try {
      double minimunWeightLoss = model.laborDetail!.initialWeight! * (model.laborDetail!.minDepreciation! / 100);
      double weightLoss = model.laborDetail!.initialWeight! - model.laborDetail!.finalWeight!;
      if (weightLoss < minimunWeightLoss) weightLoss = minimunWeightLoss;
      double normalizedLoss = weightLoss / (model.laborDetail!.initialWeight! - minimunWeightLoss);
      double score = 100 - (normalizedLoss * 100);
      model.laborDetail!.performanceScore = score;
      DateTime now = DateTime(_selectedDateAttAdmin.year, _selectedDateAttAdmin.month, _selectedDateAttAdmin.day,
          DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
      model.attendance?.checkIn = now;
      await _attendanceService.storeLaborAttendance(model);

      await getAdminAttendance();
      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Labor error: ${e.message}');
      } else {
        debugPrint('Store Attendance Labor error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> index() async {
    currentPageIndex = 0;
    filterType = 0;
    setAdminDate = DateTime.now();
    navigatorKey.currentContext!.read<DashboardViewmodel>().title = 'Absensi';
    await getAdminAttendance();
  }

  void detail(AttendanceAdminModel model) {
    _selectedAtt = model;
    currentPageIndex = 1;
  }

  void edit(AttendanceAdminModel model) {
    _selectedAtt = model;
    currentPageIndex = 2;
  }
}