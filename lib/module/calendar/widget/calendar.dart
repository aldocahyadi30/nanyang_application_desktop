import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/viewmodel/calendar_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarViewmodel>(
      builder: (context, viewmodel, child) {
        return TableCalendar(
          locale: 'id_ID',
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(_today.year, 1, 1),
          lastDay: DateTime.utc(_today.year, 12, 31),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                viewmodel.selectedList =
                    viewmodel.holiday.where((element) => isSameDay(element.date, selectedDay)).toList();
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return viewmodel.holiday.where((element) => isSameDay(element.date, day)).map((e) => e.name).toList();
          },
        );
      },
    );
  }
}