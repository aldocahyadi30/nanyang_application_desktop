import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/salary/widget/salary_index_filter.dart';
import 'package:nanyang_application_desktop/module/salary/widget/salary_table.dart';

class SalaryIndex extends StatelessWidget {
  const SalaryIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SalaryIndexFilter(),
        SizedBox(height: dynamicHeight(8, context)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: Row(
            children: [
              const Expanded(flex: 8, child: SalaryTable()),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        child: Container(),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(),
                      ),
                    ),
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