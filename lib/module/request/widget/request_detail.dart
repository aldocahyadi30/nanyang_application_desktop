import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/request.dart';
import 'package:nanyang_application_desktop/module/global/form/form_picker_field.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestDetail extends StatefulWidget {
  const RequestDetail({super.key});

  @override
  State<RequestDetail> createState() => _RequestDetailState();
}



class _RequestDetailState extends State<RequestDetail> {
  bool isLoading = false;
  final TextEditingController commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> response(BuildContext context, String type, RequestViewModel viewmodel) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          bool isTypeApproval = type == 'approve';
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              isTypeApproval ? 'Approve Perizinan' : 'Tolak Perizinan',
              style: TextStyle(color: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: commentController,
                validator: isTypeApproval
                    ? null
                    : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alasan Penolakan tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: isTypeApproval ? 'Berikan Komentar (Opsional)' : 'Alasan Penolakan (Wajib diisi)',
                  border: const OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
                  contentPadding: dynamicPaddingSymmetric(16, 16, context),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    viewmodel.selectedRequest.reason = commentController.text;

                    if (isTypeApproval) {
                      await viewmodel.response('approve');
                    } else {
                      await viewmodel.response('reject');
                    }
                  }
                },
                style:
                ElevatedButton.styleFrom(backgroundColor: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent, foregroundColor: Colors.white),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(isTypeApproval ? 'Approve' : 'Tolak'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestViewModel>(builder: (context, viewmodel, child) {
      RequestModel model = viewmodel.selectedRequest;
      return SingleChildScrollView(
        child: Column(
          children: [
            FormTextField(
              title: 'Nama',
              initialValue: model.requester.name,
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            _buildTypeField(context, model.type),
            SizedBox(height: dynamicHeight(24, context)),
            _buildDate(context, model),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Keterangan',
              initialValue: model.reason,
              maxLines: 3,
              isReadOnly: true,
            ),
            if (model.filePath != null && model.filePath!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: dynamicHeight(24, context)),
                  FormPickerField(
                    title: 'File',
                    initialValue: model.filePath?.split("/").last,
                    picker: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download, color: ColorTemplate.violetBlue),
                    ),
                  )
                ],
              ),
            if (model.status == 0)
              Column(
                children: [SizedBox(height: dynamicHeight(48, context)), Row(
                  children: [
                    Expanded(flex:8,child: Container(),),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => response(context, 'reject', viewmodel),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                          overlayColor: WidgetStateProperty.all<Color>(Colors.red.withOpacity(0.1)),
                        ),
                        child: const Text('Tolak'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => response(context, 'approve', viewmodel),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(ColorTemplate.vistaBlue),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          overlayColor: WidgetStateProperty.all<Color>(ColorTemplate.periwinkle.withOpacity(0.1)),
                        ),
                        child: const Text('Approve'),
                      ),
                    ),
                  ],
                )],
              ),
            SizedBox(height: dynamicHeight(24, context)),
            if (model.status != 0)
              Column(
                children: [
                  FormTextField(
                    title: 'Status',
                    initialValue: model.status == 1 ? 'Disetujui' : 'Ditolak',
                    isReadOnly: true,
                  ),
                  SizedBox(height: dynamicHeight(24, context)),
                  FormTextField(
                    title: 'Admin',
                    initialValue: model.status == 1 ? model.approver!.name : model.rejecter!.name,
                    isReadOnly: true,
                  ),
                  SizedBox(height: dynamicHeight(24, context)),
                  FormTextField(
                    title: 'Waktu Respon',
                    initialValue: model.status == 1
                        ? parseDateToStringFormatted(model.approvalTime!)
                        : parseDateToStringFormatted(model.rejectTime!),
                    isReadOnly: true,
                  ),
                  SizedBox(height: dynamicHeight(24, context)),
                  FormTextField(
                    title: 'Keterangan Admin',
                    initialValue: model.comment,
                    maxLines: 3,
                    isReadOnly: true,
                  ),
                ],
              )
          ],
        ),
      );
    });
  }

  Widget _buildTypeField(BuildContext context, int type) {
    String requestType = '';

    if (type == 1) {
      requestType = 'Izin Telat';
    } else if (type == 2) {
      requestType = 'Izin Pulang Cepat';
    } else if (type == 3) {
      requestType = 'Izin Tidak Masuk';
    } else if (type == 4) {
      requestType = 'Cuti Tahunan';
    } else if (type == 5) {
      requestType = 'Cuti Sakit';
    } else if (type == 6) {
      requestType = 'Cuti Hamil';
    } else if (type == 7) {
      requestType = 'Izin Lembur';
    }

    return FormTextField(
      title: 'Jenis Perizinan',
      initialValue: requestType,
      isReadOnly: true,
    );
  }

  Widget _buildDate(BuildContext context, RequestModel model) {
    if (model.type == 1 || model.type == 2) {
      return Column(
        children: [
          FormTextField(
            title: 'Tanggal',
            initialValue: parseDateToStringFormatted(model.startDateTime!),
            isReadOnly: true,
          ),
          SizedBox(height: dynamicHeight(24, context)),
          FormTextField(
            title: model.type == 1 ? 'Jam Masuk' : 'Jam Pulang',
            initialValue: parseTimeToString(model.startDateTime!),
            isReadOnly: true,
          ),
        ],
      );
    } else if (model.type == 7) {
      return Column(
        children: [
          FormTextField(
            title: 'Tanggal',
            initialValue: parseDateToStringFormatted(model.startDateTime!),
            isReadOnly: true,
          ),
          SizedBox(height: dynamicHeight(24, context)),
          FormTextField(
            title: 'Jam Lembur',
            initialValue: "${parseTimeToString(model.startDateTime!)} - ${parseTimeToString(model.endDateTime!)}",
            isReadOnly: true,
          ),
        ],
      );
    } else {
      return FormTextField(
        title: 'Tanggal',
        initialValue:
            "${parseDateToStringFormatted(model.startDateTime!)} - ${parseDateToStringFormatted(model.endDateTime!)}",
        isReadOnly: true,
      );
    }
  }
}