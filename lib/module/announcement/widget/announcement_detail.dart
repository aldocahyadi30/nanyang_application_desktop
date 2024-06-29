import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/announcement.dart';
import 'package:nanyang_application_desktop/module/global/form/form_text_field.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_button.dart';
import 'package:nanyang_application_desktop/module/global/other/nanyang_card.dart';
import 'package:nanyang_application_desktop/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementDetail extends StatelessWidget {
  const AnnouncementDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
      builder: (context, viewmodel, child) {
        AnnouncementModel model = viewmodel.selectedAnnouncement;
        return NanyangCard(
          title: Row(
            children: [
              Icon(
                Ionicons.megaphone,
                size: dynamicFontSize(24, context),
                color: Colors.black,
              ),
              SizedBox(width: dynamicWidth(8, context)),
              Text(
                'Detail Pengumuman',
                style: TextStyle(fontSize: dynamicFontSize(20, context), fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actions: [
            NanyangButton(
              size: ButtonSize.medium,
              onPressed: () => viewmodel.index(),
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
          child: Column(
            children: [
              FormTextField(
                title: 'Judul',
                initialValue: model.title,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),

              FormTextField(
                title: 'Kategori',
                initialValue: model.category.name,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),

              FormTextField(
                title: 'Isi',
                maxLines: 3,
                initialValue: model.content,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),

              FormTextField(
                title: 'Admin',
                initialValue: model.employee.name,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Tanggal Pengumuman',
                initialValue: model.postDate != null ? parseDateToStringFormatted(model.postDate!) : '',
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Durasi',
                initialValue: '${model.duration.toString()} hari',
                isReadOnly: true,
              ),
            ],
          ),
        );
      },
    );
  }
}