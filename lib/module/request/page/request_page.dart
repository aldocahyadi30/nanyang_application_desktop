import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_header.dart';
import 'package:nanyang_application_desktop/module/global/picker/nanyang_date_range_picker.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_detail.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_table.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingOnly(24, 0, 24, 24, context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            NanyangHeader(
                child: Text('Perizinan',
                    style: TextStyle(
                        fontSize: dynamicFontSize(36, context), fontWeight: FontWeight.w800, color: Colors.black))),
            SizedBox(height: dynamicHeight(8, context)),
            Selector<RequestViewModel, int>(
              selector: (context, viewmodel) => viewmodel.currentPageIndex,
              builder: (context, index, child) {
                return _buildPage(index);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: dynamicPaddingAll(16, context),
                    child: Container(
                      padding: dynamicPaddingSymmetric(0, 10, context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[600]!,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: dynamicFontSize(20, context),
                          color: ColorTemplate.violetBlue,
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
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: dynamicPaddingAll(16, context),
                    child: Container(
                      padding: dynamicPaddingSymmetric(0, 10, context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[600]!,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField(
                        value: context.watch<RequestViewModel>().filterStatus,
                        onChanged: (value) => context.read<RequestViewModel>().addFilter(status: value),
                        style: TextStyle(
                          fontSize: dynamicFontSize(24, context),
                          color: ColorTemplate.violetBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        iconEnabledColor: ColorTemplate.violetBlue,
                        decoration: InputDecoration(
                          contentPadding: dynamicPaddingSymmetric(12, 16, context),
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
                ),
              ],
            ),
            SizedBox(height: dynamicHeight(8, context)),
            SizedBox(
              width: double.infinity,
              child: RequestTable(
                actionButton: FilledButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(dynamicPaddingAll(4, context)),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<RequestViewModel>().addFilter();
                    _dateController.clear();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: dynamicFontSize(24, context),
                        color: Colors.white,
                      ),
                      SizedBox(width: dynamicWidth(4, context)),
                      Text('Refresh',
                          style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return Card(
          child: Container(
            padding: dynamicPaddingSymmetric(16, 32, context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Form Absensi',
                      style: TextStyle(fontSize: dynamicFontSize(24, context), fontWeight: FontWeight.w800),
                    ),
                    TextButton(
                      onPressed: () => context.read<RequestViewModel>().index(),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                          ),
                          Text(
                            'Kembali',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                const RequestDetail()
              ],
            ),
          ),
        );
    }
  }
}