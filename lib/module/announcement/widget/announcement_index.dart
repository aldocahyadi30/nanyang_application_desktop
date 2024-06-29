import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/announcement/widget/announcement_index_filter.dart';
import 'package:nanyang_application_desktop/module/announcement/widget/announcement_table.dart';

class AnnouncementIndex extends StatelessWidget {
  const AnnouncementIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnnouncementIndexFilter(),
        SizedBox(height: dynamicHeight(8, context)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          child: Row(
            children: [
              const Expanded(flex: 8, child: AnnouncementTable()),
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