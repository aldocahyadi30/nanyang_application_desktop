import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/holiday.dart';
import 'package:nanyang_application_desktop/viewmodel/calendar_viewmodel.dart';
import 'package:provider/provider.dart';

class CalendarEvent extends StatefulWidget {
  const CalendarEvent({super.key});

  @override
  State<CalendarEvent> createState() => _CalendarEventState();
}

class _CalendarEventState extends State<CalendarEvent> {
  @override
  Widget build(BuildContext context) {
    return Selector<CalendarViewmodel, List<HolidayModel>>(
      selector: (context, viewmodel) => viewmodel.selectedList,
      builder: (context, event, child) {
        return Column(
          children: event.isEmpty
              ? [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Tidak ada event',
                          style: TextStyle(fontSize: dynamicFontSize(20, context), color: ColorTemplate.violetBlue)))
                ]
              : event
                  .map(
                    (e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.name,
                        style: TextStyle(fontSize: dynamicFontSize(20, context), color: ColorTemplate.violetBlue),
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}