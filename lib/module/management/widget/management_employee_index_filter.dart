import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeIndexFilter extends StatefulWidget {
  const ManagementEmployeeIndexFilter({super.key});

  @override
  State<ManagementEmployeeIndexFilter> createState() => _ManagementEmployeeIndexFilterState();
}

class _ManagementEmployeeIndexFilterState extends State<ManagementEmployeeIndexFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField(
              value: context.read<EmployeeViewModel>().filterType,
              onChanged: (value) => setState(() => context.read<EmployeeViewModel>().filterType = value as int),
              style: TextStyle(
                fontSize: dynamicFontSize(24, context),
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              iconEnabledColor: ColorTemplate.violetBlue,
              decoration: InputDecoration(
                contentPadding: dynamicPaddingSymmetric(12, 16, context),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(dynamicWidth(20, context)),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(dynamicWidth(20, context)),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('Semua', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Karyawan', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Pekerja Cabutan', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        Expanded(child: Container()),
      ],
    );
  }
}