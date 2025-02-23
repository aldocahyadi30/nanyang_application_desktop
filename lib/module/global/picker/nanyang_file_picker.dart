import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';

class NanyangFilePicker extends StatefulWidget {
  // final TextEditingController? controller;
  final Color color;
  final bool isDisabled;
  final IconData icon;
  final Function(File)? onFilePicked;

  const NanyangFilePicker(
      {super.key, this.color = ColorTemplate.violetBlue, this.isDisabled = false, this.icon = Icons.attach_file, this.onFilePicked});

  @override
  State<NanyangFilePicker> createState() => _NanyangFilePickerState();
}

class _NanyangFilePickerState extends State<NanyangFilePicker> {
  Future<void> _selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      if (widget.onFilePicked != null) {
        widget.onFilePicked!(file);
      }
    } else {
      // User canceled the picker
    }
  }
  // Future<void> _selectFile(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     setState(() {
  //       Provider.of<FileProvider>(context, listen: false).setFile(file);
  //       widget.controller!.text = result.files.first.name;
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null : () => _selectFile(context),
      icon: Icon(widget.icon, color: widget.isDisabled ? Colors.grey : widget.color),
    );
  }
}