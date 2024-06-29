import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/employee.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryTable extends StatefulWidget {
  const SalaryTable({super.key});

  @override
  State<SalaryTable> createState() => _SalaryTableState();
}

class _SalaryTableState extends State<SalaryTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SalaryViewModel>(builder: (context, viewmodel, child) {
      return PaginatedDataTable2(
        header: Row(
          children: [
            Icon(
              Ionicons.cash,
              size: dynamicFontSize(24, context),
              color: Colors.black,
            ),
            SizedBox(width: dynamicWidth(8, context)),
            Text(
              'Daftar Gaji',
              style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w700),
            ),
          ],
        ),
        headingRowHeight: dynamicHeight(48, context),
        dataRowHeight: dynamicHeight(80, context),
        headingTextStyle: tableHeaderStyle(context),
        dataTextStyle: tableDataStyle(context),
        columnSpacing: dynamicWidth(8, context),
        horizontalMargin: dynamicWidth(24, context),
        columns: const <DataColumn>[
          DataColumn2(label: Text('Nama'), size: ColumnSize.L, numeric: false),
          DataColumn2(label: Text('Posisi'), size: ColumnSize.L, numeric: false),
          DataColumn2(label: Text('Periode'), size: ColumnSize.S, numeric: false),
          DataColumn2(label: Text('Status'), size: ColumnSize.S, numeric: false),
          DataColumn2(label: Text('Gaji'), size: ColumnSize.S, numeric: false),
          DataColumn2(label: Text('Action'), size: ColumnSize.S, numeric: false),
        ],
        source: DataSource(viewmodel.employeeListFiltered, context, viewmodel.selectedDate),
        rowsPerPage: 10,
      );
    });
  }
}

class DataSource extends DataTableSource {
  final List<EmployeeModel> _employee;
  final BuildContext context;
  final DateTime _date;

  DataSource(this._employee, this.context, this._date);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _employee.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    EmployeeModel model = _employee[index];
    String period = _date.year.toString() + _date.month.toString().padLeft(2, '0');
    Color rowColor = index.isEven ? Colors.grey[200]! : Colors.white;
    bool dataExist = model.thisMonthSalary != null;

    return DataRow(
      color: WidgetStateProperty.all<Color>(rowColor),
      cells: [
        DataCell(Text(
          model.name,
          overflow: TextOverflow.ellipsis,
        )),
        DataCell(Text(
          model.position.name,
          overflow: TextOverflow.ellipsis,
        )),
        DataCell(Text(period)),
        DataCell(_statusBagde(context, dataExist)),
        DataCell(
          Text(NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(model.thisMonthSalary ?? 0),
              overflow: TextOverflow.ellipsis),
        ),
        DataCell(
          SizedBox(
              width: double.infinity,
              height: dynamicHeight(40, context),
              child: dataExist
                  ? NanyangButton(
                      backgroundColor: ColorTemplate.vistaBlue,
                      onPressed: () {},
                      child: Icon(Icons.remove_red_eye,
                          size: dynamicFontSize(20, context), color: ColorTemplate.periwinkle))
                  : NanyangButton(
                      backgroundColor: Colors.yellow,
                      onPressed: () {},
                      child: Icon(Icons.edit, size: dynamicFontSize(20, context), color: Colors.black))),
        ),
      ],
    );
  }
}

TextStyle tableHeaderStyle(BuildContext context) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: dynamicFontSize(16, context),
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}

TextStyle tableDataStyle(BuildContext context) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: dynamicFontSize(16, context),
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}

TextStyle listTileTitle(BuildContext context) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: dynamicFontSize(16, context),
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}

TextStyle listTileSubtitle(BuildContext context) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: dynamicFontSize(12, context),
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );
}

Widget _statusBagde(BuildContext context, bool status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: status ? Colors.green : Colors.red,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
      status ? Ionicons.checkmark_circle : Ionicons.close_circle,
      color: Colors.white,
      size: dynamicFontSize(20, context),
    ),
  );
}