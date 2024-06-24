import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserDetail extends StatelessWidget {
  const ManagementUserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserViewModel, UserModel>(
      selector: (context, viewmodel) => viewmodel.selectedUser,
      builder: (context, user, child) {
        return Column(
          children: [
            FormTextField(
              title: 'Nama Karyawan',
              initialValue: user.employee.name,
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Email',
              initialValue: user.email,
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            _buildLevelField(context, user.level),
            SizedBox(height: dynamicHeight(24, context)),
          ],
        );
      },
    );
  }

  Widget _buildLevelField(BuildContext context, int level) {
    String name = '';

    if (level == 1) {
      name = 'User';
    } else if (level == 2) {
      name = 'Admin';
    } else if (level == 3) {
      name = 'Super Admin';
    }

    return FormTextField(
      title: 'Nama Karyawan',
      initialValue: name,
      isReadOnly: true,
    );
  }
}