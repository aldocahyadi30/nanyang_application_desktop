import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/management/widget/management_user_index_filter.dart';
import 'package:nanyang_application_desktop/module/management/widget/management_user_table.dart';

class ManagementUserIndex extends StatelessWidget {
  const ManagementUserIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ManagementUserIndexFilter(),
        SizedBox(height: dynamicHeight(8, context)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: Row(
            children: [
              const Expanded(flex: 8, child: ManagementUserTable()),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                        child: Card(
                      child: Container(),
                    )),
                    Expanded(
                        child: Card(
                      child: Container(),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}