import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/attendance/widget/attendance_index_filter.dart';
import 'package:nanyang_application_desktop/module/attendance/widget/attendance_labor_table.dart';
import 'package:nanyang_application_desktop/module/attendance/widget/attendance_status.dart';
import 'package:nanyang_application_desktop/module/attendance/widget/attendance_worker_table.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceIndex extends StatelessWidget {
  const AttendanceIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AttendanceIndexFilter(),
        SizedBox(height: dynamicHeight(8, context)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Selector<AttendanceViewModel, int>(
                  selector: (context, viewmodel) => viewmodel.filterType,
                  builder: (context, index, child) {
                    return index == 0 ? const AttendanceWorkerTable() : const AttendanceLaborTable();
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Card(
                        child: AttendanceStatus(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: Container(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}