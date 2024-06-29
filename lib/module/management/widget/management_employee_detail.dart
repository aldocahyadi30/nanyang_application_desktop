import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/employee.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_card.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeDetail extends StatelessWidget {
  const ManagementEmployeeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<EmployeeViewModel, EmployeeModel>(
      selector: (context, viewmodel) => viewmodel.selectedEmployee,
      builder: (context, employee, child) {
        return NanyangCard(
          title: Text(
            'Detail Karyawan',
            style: TextStyle(fontSize: dynamicFontSize(24, context), fontWeight: FontWeight.w800),
          ),
          actions: [
            NanyangButton(
              size: ButtonSize.medium,
              onPressed: () => context.read<EmployeeViewModel>().index(),
              backgroundColor: Colors.grey,
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: dynamicFontSize(24, context),
              ),
              child: Text(
                'Kembali',
                style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context)),
              ),
            ),
          ],
          child: Column(
            children: [
              FormTextField(
                title: 'Nama Karyawan',
                initialValue: employee.name,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Umur',
                initialValue: employee.age != null ? employee.age.toString() : '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Tempat Lahir',
                initialValue: employee.birthPlace ?? '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Tanggal Lahir',
                initialValue: employee.birthDate != null ? parseDateToStringFormatted(employee.birthDate!) : '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Alamat',
                initialValue: employee.address ?? '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Jenis Kelamin',
                initialValue: employee.gender ?? '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Nomor Telepon',
                initialValue: employee.phoneNumber ?? '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Posisi',
                initialValue: employee.position.name,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Gaji',
                initialValue: employee.salary != null ? formatCurrency(employee.salary!) : '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'ID Absensi',
                initialValue: employee.attendanceMachineID != null ? employee.attendanceMachineID.toString() : '',
                isReadOnly: true,
              ),
            ],
          ),
        );
      },
    );
  }
}