import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/request.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestTable extends StatefulWidget {
  final Widget? actionButton;

  const RequestTable({super.key, this.actionButton});

  @override
  State<RequestTable> createState() => _RequestTableState();
}

class _RequestTableState extends State<RequestTable> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _delete(int id) async {}

  @override
  Widget build(BuildContext context) {
    return Selector<RequestViewModel, List<RequestModel>>(
        selector: (context, viewmodel) => viewmodel.request,
        builder: (context, request, child) {
          return PaginatedDataTable2(
            header: Row(
              children: [
                Icon(
                  Ionicons.document,
                  size: dynamicFontSize(24, context),
                  color: Colors.black,
                ),
                SizedBox(width: dynamicWidth(8, context)),
                Text(
                  'Daftar Perizinan',
                  style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w700),
                ),
              ],
            ),
            actions: [
              if (widget.actionButton != null) widget.actionButton!,
            ],
            headingRowHeight: dynamicHeight(48, context),
            dataRowHeight: dynamicHeight(80, context),
            headingTextStyle: tableHeaderStyle(context),
            dataTextStyle: tableDataStyle(context),
            columnSpacing: dynamicWidth(8, context),
            horizontalMargin: dynamicWidth(24, context),
            renderEmptyRowsInTheEnd: false,
            minWidth: dynamicWidth(800, context),
            columns: <DataColumn>[
              DataColumn2(label: const Text('Karyawan'), numeric: false, fixedWidth: dynamicWidth(250, context)),
              const DataColumn2(label: Text('Jenis'), numeric: false, size: ColumnSize.M),
              const DataColumn2(label: Text('Tanggal Mulai'), numeric: false),
              const DataColumn2(label: Text('Tanggal Selesai'), numeric: false),
              const DataColumn2(label: Text('Status'), numeric: false),
              DataColumn2(label: const Text('Admin'), numeric: false, fixedWidth: dynamicWidth(150, context)),
              const DataColumn2(label: Text('Action'), numeric: false, size: ColumnSize.S),
            ],
            source: DataSource(request, context),
            rowsPerPage: 10,
          );
        });
  }
}

class DataSource extends DataTableSource {
  final List<RequestModel> _request;
  final BuildContext context;

  DataSource(this._request, this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _request.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    RequestModel model = _request[index];
    String? startDate = model.startDateTime != null ? parseDateToStringFormatted(model.startDateTime!) : null;
    String? endDate = model.endDateTime != null ? parseDateToStringFormatted(model.endDateTime!) : null;
    String typeName = '';
    String adminName = '';

    if (model.status == 1 && model.approver?.id != null) {
      adminName = model.approver!.name;
    } else if (model.status == 2 && model.rejecter?.id != null) {
      adminName = model.rejecter!.name;
    }

    switch (model.type) {
      case 1:
        typeName = 'Izin Telat';
        break;
      case 2:
        typeName = 'Izin Pulang Cepat';
        break;
      case 3:
        typeName = 'Izin Tidak Masuk';
        break;
      case 4:
        typeName = 'Cuti Tahunan';
        break;
      case 5:
        typeName = 'Cuti Sakit';
        break;
      case 6:
        typeName = 'Cuti Melahirkan';
        break;
      case 7:
        typeName = 'Izin Lembur';
        break;
    }
    Color rowColor = index.isEven ? Colors.grey[200]! : Colors.white;

    return DataRow(
      color: WidgetStateProperty.all<Color>(rowColor),
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: dynamicWidth(24, context),
                backgroundColor: Colors.black,
                child: Text(model.requester.initials!,
                    style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context))),
              ),
              SizedBox(width: dynamicWidth(12, context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.requester.shortedName!,
                    style: listTileTitle(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    model.requester.position.name,
                    style: listTileSubtitle(context),
                  ),
                ],
              )
            ],
          ),
        ),
        DataCell(Text(typeName)),
        DataCell(Text(startDate ?? '-')),
        DataCell(Text(endDate ?? '-')),
        DataCell(_statusBadge(context, model.status)),
        DataCell(Text(
          adminName,
          overflow: TextOverflow.ellipsis,
        )),
        DataCell(_actionButton(context, model.status, model)),
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

Widget _statusBadge(BuildContext context, int status) {
  String? text = '';
  Color? badgeColor = Colors.white;
  Color? textColor = Colors.black;

  switch (status) {
    case 0:
      text = 'Pending';
      badgeColor = Colors.yellow;
      textColor = Colors.black;
      break;
    case 1:
      text = 'Approved';
      badgeColor = Colors.green;
      textColor = Colors.white;
      break;
    case 2:
      text = 'Ditolak';
      badgeColor = Colors.red;
      textColor = Colors.white;
      break;
    default:
      text = 'Pending';
      badgeColor = Colors.yellow;
      textColor = Colors.black;
      break;
  }

  return Container(
    padding: dynamicPaddingAll(8, context),
    decoration: BoxDecoration(
      color: badgeColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text,
        style: TextStyle(color: textColor, fontSize: dynamicFontSize(12, context), fontWeight: FontWeight.w500)),
  );
}

Widget _actionButton(BuildContext context, int status, RequestModel model) {
  if (status == 1) {
    return SizedBox(
      height: dynamicHeight(40, context),
      width: double.infinity,
      child: NanyangButton(
        backgroundColor: ColorTemplate.vistaBlue,
        onPressed: () => context.read<RequestViewModel>().detail(model),
        child: Icon(Icons.remove_red_eye, color: ColorTemplate.periwinkle, size: dynamicFontSize(20, context)),
      ),
    );
  } else {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: dynamicHeight(40, context),
            child: NanyangButton(
              backgroundColor: ColorTemplate.vistaBlue,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              onPressed: () => context.read<RequestViewModel>().detail(model),
              child: Icon(Icons.remove_red_eye, size: dynamicFontSize(20, context), color: ColorTemplate.periwinkle),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: dynamicHeight(40, context),
            child: NanyangButton(
              backgroundColor: Colors.red,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Hapus Perizinan'),
                          content: const Text('Apakah Anda yakin ingin menghapus perizinan ini?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                                overlayColor: WidgetStateProperty.all<Color>(Colors.red.withOpacity(0.1)),
                              ),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await context.read<RequestViewModel>().delete(model.id).then((_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Perizinan berhasil dihapus')));
                                  Navigator.pop(context);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                overlayColor: WidgetStateProperty.all<Color>(Colors.red.withOpacity(0.1)),
                              ),
                              child: const Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: dynamicFontSize(20, context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}