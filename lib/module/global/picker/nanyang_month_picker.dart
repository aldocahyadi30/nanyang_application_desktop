import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class NanyangMonthPicker extends StatefulWidget {
  final TextEditingController? controller;
  final Color color;
  final DateTime? selectedDate;
  final bool isDisabled;
  final Function(DateTime)? onDatePicked;
  const NanyangMonthPicker({super.key, this.controller, this.color = Colors.blue, this.selectedDate, this.isDisabled = false, this.onDatePicked});

  @override
  State<NanyangMonthPicker> createState() => _NanyangMonthPickerState();
}

class _NanyangMonthPickerState extends State<NanyangMonthPicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      Future.delayed(Duration.zero, () {
        selectedDate = widget.selectedDate!;
        widget.controller!.text = DateFormat('MMMM yyyy').format(selectedDate);
      });
    } else {
      Future.delayed(Duration.zero, () {
        selectedDate = DateTime.now();
      });
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        if (widget.controller != null) {
          widget.controller!.text = DateFormat('MMMM yyyy').format(selectedDate);
        }
      });

      if (widget.onDatePicked != null) {
        widget.onDatePicked!(selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null : () => _selectMonth(context),
      icon: Icon(Icons.calendar_today, color: widget.isDisabled ? Colors.grey : widget.color),
    );
  }
}