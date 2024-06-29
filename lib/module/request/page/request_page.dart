import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_detail.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_index.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: dynamicPaddingSymmetric(0, 24, context),
      child: Column(
        children: [
          Selector<RequestViewModel, int>(
            selector: (context, viewmodel) => viewmodel.currentPageIndex,
            builder: (context, index, child) {
              return _buildPage(index);
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const RequestIndex();
      default:
        return const RequestDetail();
    }
  }
}