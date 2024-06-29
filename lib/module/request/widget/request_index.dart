import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_index_filter.dart';
import 'package:nanyang_application_desktop/module/request/widget/request_table.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestIndex extends StatelessWidget {
  const RequestIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RequestIndexFilter(),
        SizedBox(height: dynamicHeight(8, context)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: RequestTable(
                  actionButton: NanyangButton(
                    size: ButtonSize.medium,
                    onPressed: () {
                      context.read<RequestViewModel>().addFilter();
                      //TODO fix clear date controller text
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: dynamicFontSize(24, context),
                    ),
                    backgroundColor: Colors.grey,
                    child: Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context)),
                    ),
                  ),
                ),
              ),
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
                  ))
            ],
          ),
        ),
      ],
    );
  }
}