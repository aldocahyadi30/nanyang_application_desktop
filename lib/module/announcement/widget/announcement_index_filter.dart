import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementIndexFilter extends StatefulWidget {
  const AnnouncementIndexFilter({super.key});

  @override
  State<AnnouncementIndexFilter> createState() => _AnnouncementIndexFilterState();
}

class _AnnouncementIndexFilterState extends State<AnnouncementIndexFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<AnnouncementViewModel>(
            builder: (context, viewmodel, child) {
              List<DropdownMenuItem<int>> items = [
                DropdownMenuItem(
                  value: 0, // Set value to 0 for "All categories"
                  child: Text('Semua Kategori', style: TextStyle(fontSize: dynamicFontSize(24, context))),
                ),
                ...viewmodel.announcementCategory.map((e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(e.name, style: TextStyle(fontSize: dynamicFontSize(24, context))),
                )),
              ];
              return Card(
                margin: EdgeInsets.zero,
                child: DropdownButtonFormField(
                  value: viewmodel.filterCategory,
                  onChanged: (value) => viewmodel.filterCategory = value as int,
                  style: TextStyle(
                    fontSize: dynamicFontSize(24, context),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  iconEnabledColor: ColorTemplate.violetBlue,
                  decoration: InputDecoration(
                    contentPadding: dynamicPaddingSymmetric(12, 16, context),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(dynamicWidth(20, context)),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(dynamicWidth(20, context)),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  items: items,
                ),
              );
            },
          ),
        ),
        Expanded(child: Container()),
        Expanded(child: Container()),
      ],
    );
  }
}