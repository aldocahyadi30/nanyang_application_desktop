import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/module/calendar/widget/calendar.dart';
import 'package:nanyang_application_desktop/module/calendar/widget/calendar_event.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_card.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: dynamicPaddingSymmetric(0, 24, context),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  const Expanded(flex: 8, child: Calendar()),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: NanyangCard(
                            title: Row(
                              children: [
                                Icon(
                                  Ionicons.calendar_number,
                                  size: dynamicFontSize(24, context),
                                  color: Colors.black,
                                ),
                                SizedBox(width: dynamicWidth(8, context)),
                                Text(
                                  'Event',
                                  style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            actions: const [],
                            child: const CalendarEvent(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}