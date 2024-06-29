import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/announcement.dart';
import 'package:nanyang_application_desktop/model/announcement_category.dart';
import 'package:nanyang_application_desktop/module/global/form/form_button.dart';
import 'package:nanyang_application_desktop/module/global/form/form_dropdown.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_card.dart';
import 'package:nanyang_application_desktop/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementForm extends StatefulWidget {
  const AnnouncementForm({super.key});

  @override
  State<AnnouncementForm> createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final _formKey = GlobalKey<FormState>();
  late final AnnouncementViewModel _viewModel;
  late final AnnouncementModel _model;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool isLoadingPost = false;
  bool isLoadingSave = false;
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<AnnouncementViewModel>();
    if (_viewModel.selectedAnnouncement.id != 0) {
      isEdit = true;
      _model = AnnouncementModel.copyWith(_viewModel.selectedAnnouncement);
    } else {
      isEdit = false;
      _model = _viewModel.selectedAnnouncement;
    }

    titleController.text = _model.title;
    contentController.text = _model.content;
    dateController.text = _model.postDate != null ? parseDateToStringFormatted(_model.postDate!) : '';
    timeController.text = _model.postDate != null ? parseTimeToString(_model.postDate!) : '';
    durationController.text = _model.duration.toString();
  }

  @override
  Widget build(BuildContext context) {
    return NanyangCard(
      title: Row(
        children: [
          Icon(
            Ionicons.document_text,
            size: dynamicFontSize(24, context),
            color: Colors.black,
          ),
          SizedBox(width: dynamicWidth(8, context)),
          Text(
            'Form Absensi',
            style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        NanyangButton(
          size: ButtonSize.medium,
          onPressed: () => _viewModel.index(),
          backgroundColor: Colors.grey,
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: dynamicFontSize(24, context),
          ),
          child: Text(
            'Kembali',
            style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context)),
          ),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Selector<AnnouncementViewModel, List<AnnouncementCategoryModel>>(
              selector: (context, model) => model.announcementCategory,
              builder: (context, categories, _) {
                return FormDropdown(
                  title: 'Kategori Pengumuman',
                  items: categories.isEmpty
                      ? []
                      : categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  value: _model.category.id != 0 ? _model.category.id : null,
                  onChanged: (value) {
                    setState(() {
                      _model.category = categories.firstWhere((element) => element.id == value);
                    });
                  },
                );
              },
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Judul Pengumuman',
              controller: titleController,
              onChanged: (value) => _model.title = value!,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Isi Pengumuman',
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (value) => _model.content = value!,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Durasi Pengumuman',
              controller: durationController,
              keyboardType: TextInputType.number,
              onChanged: (value) => _model.duration = int.parse(value!),
            ),
            SizedBox(height: dynamicHeight(32, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FormButton(
                  text: 'Simpan',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // await send();
                    }
                  },
                  backgroundColor: Colors.white,
                  textColor: ColorTemplate.lightVistaBlue,
                  isLoading: isLoadingSave,
                  elevation: 8,
                ),
                SizedBox(width: dynamicWidth(16, context)),
                FormButton(
                  text: 'Kirim',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // await send();
                    }
                  },
                  backgroundColor: ColorTemplate.lightVistaBlue,
                  isLoading: isLoadingPost,
                  elevation: 8,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}