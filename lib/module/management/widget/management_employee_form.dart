import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/employee.dart';
import 'package:nanyang_application_desktop/model/position.dart';
import 'package:nanyang_application_desktop/module/global/form/form_button.dart';
import 'package:nanyang_application_desktop/module/global/form/form_dropdown.dart';
import 'package:nanyang_application_desktop/module/global/form/form_picker_field.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_card.dart';
import 'package:nanyang_application_desktop/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application_desktop/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeForm extends StatefulWidget {
  const ManagementEmployeeForm({super.key});

  @override
  State<ManagementEmployeeForm> createState() => _ManagementEmployeeFormState();
}

class _ManagementEmployeeFormState extends State<ManagementEmployeeForm> {
  late final EmployeeViewModel _employeeViewModel;
  late final EmployeeModel _model;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthplaceController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _attendanceIDController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  bool isEdit = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _employeeViewModel = context.read<EmployeeViewModel>();

    if (_employeeViewModel.selectedEmployee.id == 0) {
      _model = _employeeViewModel.selectedEmployee;
    } else {
      _model = EmployeeModel.copyWith(_employeeViewModel.selectedEmployee);
      isEdit = true;
      _nameController.text = _model.name;
      _birthplaceController.text = _model.birthPlace ?? '';
      _birthdateController.text = _model.birthDate != null ? parseDateToStringFormatted(_model.birthDate!) : '';
      _addressController.text = _model.address ?? '';
      _phoneController.text = _model.phoneNumber ?? '';
      _salaryController.text = _model.salary != null ? formatCurrency(_model.salary!) : '';
      _attendanceIDController.text = _model.attendanceMachineID != null ? _model.attendanceMachineID.toString() : '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _birthplaceController.dispose();
    _birthdateController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _attendanceIDController.dispose();
    _entryDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NanyangCard(
      title: Text(
        'Form Karyawan',
        style: TextStyle(fontSize: dynamicFontSize(24, context), fontWeight: FontWeight.w800),
      ),
      actions: [
        NanyangButton(
          size: ButtonSize.medium,
          onPressed: () => _employeeViewModel.index(),
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormTextField(
              title: 'Nama Karyawan',
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _model.name = value!;
                });
              },
            ),
            SizedBox(height: dynamicHeight(24, context)),
            Selector<ConfigurationViewModel, List<PositionModel>>(
              selector: (context, viewmodel) => viewmodel.position,
              builder: (context, position, child) {
                return FormDropdown<int>(
                  title: 'Posisi',
                  value: isEdit ? _model.position.id : null,
                  items: position.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _model.position = position.firstWhere((element) => element.id == value);
                    });
                  },
                );
              },
            ),
            SizedBox(height: dynamicHeight(24, context)),
            if (!isEdit)
              Column(
                children: [
                  FormPickerField(
                      title: 'Tanggal Masuk',
                      picker: NanyangDatePicker(
                        selectedDate: _model.entryDate,
                        controller: _entryDateController,
                        onDatePicked: (date) {
                          _entryDateController.text = parseDateToStringFormatted(date);
                          _model.entryDate = date;
                        },
                      ),
                      controller: _entryDateController),
                  SizedBox(height: dynamicHeight(24, context)),
                ],
              ),
            FormTextField(
              title: 'Nomor Telepon',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _model.phoneNumber = value;
                }
              },
            ),
            if (isEdit)
              Column(
                children: [
                  FormTextField(
                    title: 'Alamat',
                    controller: _addressController,
                    isRequired: false,
                    onChanged: (value) {
                      if (value!.isNotEmpty) {
                        _model.address = value;
                      }
                    },
                  ),
                  SizedBox(height: dynamicHeight(16, context)),
                  FormTextField(
                    title: 'Tempat Lahir',
                    controller: _birthplaceController,
                    isRequired: false,
                    onChanged: (value) {
                      if (value!.isNotEmpty) {
                        _model.birthPlace = value;
                      }
                    },
                  ),
                  SizedBox(height: dynamicHeight(16, context)),
                  FormPickerField(
                      title: 'Tanggal Lahir',
                      isRequired: false,
                      picker: NanyangDatePicker(
                        selectedDate: _model.birthDate,
                        controller: _birthdateController,
                        onDatePicked: (date) {
                          _birthdateController.text = parseDateToStringFormatted(date);
                          _model.birthDate = date;
                          _model.age = DateTime.now().year - date.year;
                        },
                      ),
                      controller: _birthdateController),
                  SizedBox(height: dynamicHeight(16, context)),
                  FormDropdown(
                    title: 'Jenis Kelamin',
                    isRequired: false,
                    value: _model.gender,
                    items: const [
                      DropdownMenuItem(value: 'Pria', child: Text('Pria')),
                      DropdownMenuItem(value: 'Wanita', child: Text('Wanita'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        _model.gender = value.toString();
                      });
                    },
                  ),
                  SizedBox(height: dynamicHeight(16, context)),
                ],
              ),
            if (context.read<AuthViewModel>().user.level == 3)
              Column(
                children: [
                  SizedBox(
                    height: dynamicHeight(24, context),
                  ),
                  FormTextField(
                    title: 'Gaji',
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [formatInputCurrencty()],
                    onChanged: (value) {
                      if (value!.isNotEmpty) _model.salary = removeCurrencyFormat(value);
                    },
                  ),
                ],
              ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'ID Mesin Absensi',
              controller: _attendanceIDController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _model.attendanceMachineID = int.parse(value);
                }
              },
            ),
            SizedBox(height: dynamicHeight(32, context)),
            Align(
              alignment: Alignment.centerRight,
              child: FormButton(
                text: 'Simpan Karyawan',
                isLoading: _isLoading,
                backgroundColor: ColorTemplate.lightVistaBlue,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    // if (_isLabor) {
                    //   _viewmodel.storeLabor(_model);
                    // } else {
                    //   _viewmodel.storeWorker(_model);
                    // }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}