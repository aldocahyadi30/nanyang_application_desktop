import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserIndexFilter extends StatefulWidget {
  const ManagementUserIndexFilter({super.key});

  @override
  State<ManagementUserIndexFilter> createState() => _ManagementUserIndexFilterState();
}

class _ManagementUserIndexFilterState extends State<ManagementUserIndexFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: DropdownButtonFormField(
              value: context.read<UserViewModel>().filterLevel,
              onChanged: (value) {
                setState(() {
                  context.read<UserViewModel>().filterLevel = value as int;
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
                  child: Text('Semua', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('User', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Admin', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Super Admin', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        Expanded(child: Container()),
      ],
    );
  }
}