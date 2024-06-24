import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/request.dart';
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
          return Scrollbar(
            controller: _scrollController,
            child: PaginatedDataTable(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Perizinan',
                    style: TextStyle(fontSize: dynamicFontSize(24, context), fontWeight: FontWeight.w700),
                  ),
                  if (widget.actionButton != null) widget.actionButton!,
                ],
              ),
              headingRowHeight: dynamicHeight(48, context),
              dataRowMinHeight: dynamicHeight(48, context),
              dataRowMaxHeight: dynamicHeight(64, context),
              showEmptyRows: false,
              controller: _scrollController,
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Karyawan', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Jenis', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Tanggal Mulai', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Tanggal Selesai', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Status', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Admin', style: tableHeaderStyle(context)))),
                DataColumn(label: Expanded(child: Text('Action', style: tableHeaderStyle(context)))),
              ],
              source: DataSource(request, context),
              rowsPerPage: 10,
            ),
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

    return DataRow(cells: [
      DataCell(Text(model.requester.name, style: tableDataStyle(context))),
      DataCell(Text(typeName, style: tableDataStyle(context))),
      DataCell(Text(startDate ?? '-', style: tableDataStyle(context))),
      DataCell(Text(endDate ?? '-', style: tableDataStyle(context))),
      DataCell(_statusBadge(context, model.status)),
      DataCell(Text(adminName, style: tableDataStyle(context))),
      DataCell(_actionButton(context, model.status, model)),
    ]);
  }
}

TextStyle tableHeaderStyle(BuildContext context) {
  return TextStyle(
    fontSize: dynamicFontSize(24, context),
    fontWeight: FontWeight.bold,
  );
}

TextStyle tableDataStyle(BuildContext context) {
  return TextStyle(
    fontSize: dynamicFontSize(20, context),
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
        style: TextStyle(color: textColor, fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.w500)),
  );
}

Widget _actionButton(BuildContext context, int status, RequestModel model) {
  if (status == 1) {
    return FilledButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(dynamicPaddingAll(8, context)),
        backgroundColor: WidgetStateProperty.all<Color>(ColorTemplate.vistaBlue),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: () => context.read<RequestViewModel>().detail(model),
      child: const Icon(
        Icons.remove_red_eye,
        color: ColorTemplate.periwinkle,
      ),
    );
  } else {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(dynamicPaddingAll(8, context)),
              backgroundColor: WidgetStateProperty.all<Color>(ColorTemplate.vistaBlue),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
            onPressed: () => context.read<RequestViewModel>().detail(model),
            child: const Icon(
              Icons.remove_red_eye,
              color: ColorTemplate.periwinkle,
            ),
          ),
        ),
        Expanded(
          child: FilledButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(dynamicPaddingAll(8, context)),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, StateSetter setState) {
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
                  });
                },
              );
            },
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}