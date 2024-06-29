import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/salary/widget/salary_index.dart';
import 'package:nanyang_application_desktop/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: dynamicPaddingSymmetric(0, 24, context),
      child: Column(
        children: [
          Selector<SalaryViewModel, int>(
            selector: (context, viewmodel) => viewmodel.currentPageIndex,
            builder: (context, index, child) {
              return _buildPage(index);
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage(int type) {
    if (type == 0) {
      return const SalaryIndex();
    } else {
      return Container();
    }
  }
}