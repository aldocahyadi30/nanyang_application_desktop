import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/announcement/page/announcement_page.dart';
import 'package:nanyang_application_desktop/module/attendance/page/attendance_page.dart';
import 'package:nanyang_application_desktop/module/chat/page/chat_page.dart';
import 'package:nanyang_application_desktop/module/dashboard/page/dashboard_page.dart';
import 'package:nanyang_application_desktop/module/management/page/management_employee_page.dart';
import 'package:nanyang_application_desktop/module/management/page/management_user_page.dart';
import 'package:nanyang_application_desktop/module/request/page/request_page.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int? selectedIndex;
  const HomeScreen({super.key, this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isExpanded = true;
  late final UserModel _user;
  final DashboardPage _dashboardPage = const DashboardPage();
  final AttendancePage _attendancePage = const AttendancePage();
  final ManagementUserPage _managementUserPage = const ManagementUserPage();
  final ManagementEmployeePage _managementEmployeePage = const ManagementEmployeePage();
  final RequestPage _requestPage = const RequestPage();
  final AnnouncementPage _announcementPage = const AnnouncementPage();
  final ChatPage _chatPage = const ChatPage();
  Widget _currentPage = const DashboardPage();


  @override
  void initState() {
    super.initState();
    _user = context.read<ConfigurationViewModel>().user;
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentPage = _dashboardPage;
          break;
        case 1:
          _currentPage = _attendancePage;
          context.read<AttendanceViewModel>().index();
          break;
        case 2:
          _currentPage = _managementUserPage;
          break;
        case 3:
          _currentPage = _managementEmployeePage;
          break;
        case 6:
          _currentPage = _requestPage;
          context.read<RequestViewModel>().index();
          break;
        case 7:
          _currentPage = _announcementPage;
          break;
        case 8:
          _currentPage = _chatPage;
          break;
        default:
          _currentPage = _dashboardPage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              extended: isExpanded,
              backgroundColor: ColorTemplate.violetBlue,
              indicatorColor: ColorTemplate.periwinkle,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              leading: isExpanded
                  ? Row(
                      children: [
                        SvgPicture.asset('assets/svg/logo.svg', width: 40, height: 40),
                        SizedBox(
                          width: dynamicWidth(16, context),
                        ),
                        Text('Nanyang Mobile', style: TextStyle(color: Colors.black, fontSize: dynamicFontSize(32, context), fontWeight: FontWeight.w800))
                      ],
                    )
                  : Image.asset('assets/image/logo-nanyang.png', width: 40, height: 40),
              trailing: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(isExpanded ? Ionicons.chevron_back : Ionicons.menu, color: Colors.white),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.home_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.home,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Home', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.stopwatch_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.stopwatch,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Absensi', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.person_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.person,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('User', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.people_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.people,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Karyawan', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.bar_chart_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.bar_chart,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Peforma', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.cash_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.cash,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Gaji', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.document_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.document,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Perizinan', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.megaphone_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.megaphone,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Pengumuman', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.chatbox_ellipses_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.chatbox_ellipses,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Help Chat', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.book_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.book,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Guidebook', style: TextStyle(color: Colors.white))),
                NavigationRailDestination(
                    icon: Icon(
                      Ionicons.settings_outline,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Ionicons.settings,
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    label: Text('Pengaturan', style: TextStyle(color: Colors.white))),
              ],
            ),
            Expanded(
              child: _currentPage,
            )
          ],
        ),
      ),
    );
  }
}