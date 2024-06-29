import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/attendance_admin.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceStatus extends StatelessWidget {
  const AttendanceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AttendanceViewModel, List<AttendanceAdminModel>>(
      selector: (context, viewmodel) => context.read<AttendanceViewModel>().filterType  == 0 ? viewmodel.attendanceWorker : viewmodel.attendanceLabor,
      builder: (context, attendance, child) {
        return Column(
          children: [
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                        radius: dynamicWidth(72, context),
                        backgroundColor: Colors.green,
                        child: Text(
                          attendance.where((element) => element.attendance != null && element.attendance?.inStatus == 1).length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 48),
                        )),
                    CircleAvatar(
                        radius: dynamicWidth(72, context),
                        backgroundColor: Colors.red,
                        child: Text(
                          attendance.where((element) => element.attendance != null && element.attendance?.inStatus == 0).length.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 48),
                        )),
                    CircleAvatar(
                        radius: dynamicWidth(72, context),
                        backgroundColor: Colors.yellow,
                        child: Text(
                          attendance.where((element) => element.attendance != null && element.attendance?.inStatus == 2).length.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 48),
                        )),
                  ],
                )),
          ],
        );
      },
    );
  }
}