import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/global/picker/nanyang_month_picker.dart';
import 'package:nanyang_application_desktop/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryIndexFilter extends StatefulWidget {
  const SalaryIndexFilter({super.key});

  @override
  State<SalaryIndexFilter> createState() => _SalaryIndexFilterState();
}

class _SalaryIndexFilterState extends State<SalaryIndexFilter> {
  final TextEditingController _dateController = TextEditingController();
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = context.read<SalaryViewModel>().selectedDate;
    _dateController.text = DateFormat('MMMM yyyy').format(date);
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField(
              value: context.read<SalaryViewModel>().filterType,
              onChanged: (value) {
                setState(() {
                  context.read<SalaryViewModel>().filterType = value as int;
                });
              },
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
                  child: Text('Karyawan', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Pekerja Cabutan', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: dynamicWidth(16, context)),
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: TextFormField(
              readOnly: true,
              controller: _dateController,
              style: TextStyle(
                fontSize: dynamicFontSize(20, context),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: dynamicPaddingSymmetric(12, 16, context),
                suffixIcon: NanyangMonthPicker(
                  controller: _dateController,
                  color: ColorTemplate.violetBlue,
                  selectedDate: date,
                  onDatePicked: (picked) {
                    _dateController.text = DateFormat('MMMM yyyy').format(picked);
                    context.read<SalaryViewModel>().selectedDate = picked;
                    context.read<SalaryViewModel>().getEmployee();
                  },
                ),
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
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}