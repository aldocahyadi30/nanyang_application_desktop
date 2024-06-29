import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application_desktop/module/global/picker/nanyang_date_range_picker.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestIndexFilter extends StatefulWidget {
  const RequestIndexFilter({super.key});

  @override
  State<RequestIndexFilter> createState() => _RequestIndexFilterState();
}

class _RequestIndexFilterState extends State<RequestIndexFilter> {
  final TextEditingController _dateController = TextEditingController();

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
            child: TextFormField(
              readOnly: true,
              controller: _dateController,
              style: TextStyle(
                fontSize: dynamicFontSize(20, context),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: dynamicPaddingSymmetric(12, 16, context),
                suffixIcon: NanyangDateRangePicker(
                  controller: _dateController,
                  color: ColorTemplate.violetBlue,
                  selectedDateRange: context.read<RequestViewModel>().filterDate,
                  onDateRangePicked: (picked) {
                    _dateController.text =
                    '${parseDateToStringFormatted(picked.start)} - ${parseDateToStringFormatted(picked.end)}';
                    context.read<RequestViewModel>().addFilter(date: picked);
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
        SizedBox(width: dynamicWidth(16, context)),
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField(
              value: context.watch<RequestViewModel>().filterStatus,
              onChanged: (value) => context.read<RequestViewModel>().addFilter(status: value),
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
                  value: '',
                  child: Text('Semua', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 'Pending',
                  child: Text('Pending', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 'Approved',
                  child: Text('Disetujui', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 'Rejected',
                  child: Text('Ditolak', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container())
      ],
    );
  }
}