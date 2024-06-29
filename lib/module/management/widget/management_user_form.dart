import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/employee.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/global/form/form_button.dart';
import 'package:nanyang_application_desktop/module/global/form/form_dropdown.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserForm extends StatefulWidget {
  const ManagementUserForm({super.key});

  @override
  State<ManagementUserForm> createState() => _ManagementUserFormState();
}

class _ManagementUserFormState extends State<ManagementUserForm> {
  late final AuthViewModel _authViewModel;
  late final UserModel _model;
  late final UserModel _user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  bool isEdit = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
    _authViewModel = context.read<AuthViewModel>();
    if (context.read<UserViewModel>().selectedUser.id == '') {
      _model = context.read<UserViewModel>().selectedUser;
    } else {
      _model = UserModel.copyWith(context.read<UserViewModel>().selectedUser);
      isEdit = true;
      _emailController.text = _model.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Selector<EmployeeViewModel, List<EmployeeModel>>(
            selector: (context, viewmodel) => viewmodel.employee,
            builder: (context, employee, child) {
              return FormDropdown(
                title: 'Karyawan',
                items: employee.isEmpty
                    ? []
                    : employee.map((employee) {
                        return DropdownMenuItem<int>(
                          value: employee.id,
                          child: Text(employee.name),
                        );
                      }).toList(),
                value: _model.employee.id != 0 ? _model.employee.id : null,
                onChanged: (value) {
                  setState(() {
                    _model.employee = employee.firstWhere((element) => element.id == value);
                  });
                },
              );
            },
          ),
          SizedBox(height: dynamicHeight(24, context)),
          FormDropdown(
            title: 'Level',
            items: _user.level == 3
                ? [
                    const DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Karyawan'),
                    ),
                    const DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Admin'),
                    ),
                    const DropdownMenuItem(
                      value: 3,
                      child: Text('Super Admin'),
                    ),
                  ]
                : [
                    const DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Karyawan'),
                    ),
                    const DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Admin'),
                    ),
                  ],
            value: _model.level != 0 ? _model.level : null,
            onChanged: (value) {
              setState(() {
                _model.level = value!;
              });
            },
          ),
          SizedBox(height: dynamicHeight(24, context)),
          FormTextField(
            title: 'Email',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tolong isi inputan ini';
              }
              if (!value.contains('@')) {
                return 'Email tidak valid';
              }
              return null;
            },
            onChanged: (value) {
              _model.email = value!;
            },
          ),
          SizedBox(
            height: dynamicHeight(16, context),
          ),
          if (!isEdit)
            Column(
              children: [
                FormTextField(
                  title: 'Password',
                  controller: _passwordController,
                  isObscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong isi inputan ini';
                    }

                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: dynamicHeight(16, context),
                ),
                FormTextField(
                  title: 'Masukan Ulang Password',
                  isObscure: true,
                  controller: _retypePasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong isi inputan ini';
                    }

                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }

                    if (value != _passwordController.text) {
                      return 'Password tidak sama';
                    }
                    return null;
                  },
                ),
              ],
            ),
          SizedBox(height: dynamicHeight(32, context)),
          FormButton(
            text: 'Simpan User',
            isLoading: _isLoading,
            backgroundColor: ColorTemplate.lightVistaBlue,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });

                if (isEdit) {
                  // _viewmodel.storeLabor(_model);
                } else {
                  // _viewmodel.storeWorker(_model);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}