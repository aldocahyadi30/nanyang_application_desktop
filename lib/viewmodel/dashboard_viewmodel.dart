import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardViewmodel extends ChangeNotifier {
  String _title = '';


  String get title => _title;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  Future<void> index() async {
    title = '';
    await navigatorKey.currentContext!.read<EmployeeViewModel>().getCount();
    await navigatorKey.currentContext!.read<AttendanceViewModel>().getCount();
    await navigatorKey.currentContext!.read<RequestViewModel>().getRequest();
  }
}