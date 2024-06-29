import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nanyang_application_desktop/color_template.dart';
import 'package:nanyang_application_desktop/helper.dart';
import 'package:nanyang_application_desktop/model/user.dart';
import 'package:nanyang_application_desktop/module/announcement/page/announcement_page.dart';
import 'package:nanyang_application_desktop/module/attendance/page/attendance_page.dart';
import 'package:nanyang_application_desktop/module/calendar/page/calendar_page.dart';
import 'package:nanyang_application_desktop/module/chat/page/chat_page.dart';
import 'package:nanyang_application_desktop/module/dashboard/page/dashboard_page.dart';
import 'package:nanyang_application_desktop/module/management/page/management_employee_page.dart';
import 'package:nanyang_application_desktop/module/management/page/management_user_page.dart';
import 'package:nanyang_application_desktop/module/request/page/request_page.dart';
import 'package:nanyang_application_desktop/module/salary/page/salary_page.dart';
import 'package:nanyang_application_desktop/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/calendar_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/chat_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/dashboard_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/salary_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
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
  final SalaryPage _salaryPage = const SalaryPage();
  final RequestPage _requestPage = const RequestPage();
  final AnnouncementPage _announcementPage = const AnnouncementPage();
  final ChatPage _chatPage = const ChatPage();
  final CalendarPage _calendarPage = const CalendarPage();
  Widget _currentPage = const DashboardPage();

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
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
          context.read<DashboardViewmodel>().index();
          break;
        case 1:
          _currentPage = _attendancePage;
          context.read<AttendanceViewModel>().index();
          break;
        case 2:
          _currentPage = _managementUserPage;
          context.read<UserViewModel>().index();
          break;
        case 3:
          _currentPage = _managementEmployeePage;
          context.read<EmployeeViewModel>().index();
          break;
        case 5:
          _currentPage = _salaryPage;
          context.read<SalaryViewModel>().index();
          break;
        case 6:
          _currentPage = _requestPage;
          context.read<RequestViewModel>().index();
          break;
        case 7:
          _currentPage = _announcementPage;
          context.read<AnnouncementViewModel>().index();
          break;
        case 8:
          _currentPage = _chatPage;
          context.read<ChatViewModel>().index();
          break;
        case 9:
          _currentPage = _calendarPage;
          context.read<CalendarViewmodel>().index();
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            extended: isExpanded,
            backgroundColor: ColorTemplate.violetBlue,
            indicatorColor: ColorTemplate.periwinkle,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            elevation: 10,
            // minExtendedWidth: dynamicWidth(400, context),
            leading: Row(
              children: [
                SvgPicture.asset('assets/svg/logo.svg',
                    width: dynamicWidth(56, context), height: dynamicHeight(56, context)),
                if (isExpanded)
                  Row(
                    children: [
                      SizedBox(
                        width: dynamicWidth(16, context),
                      ),
                      Text('Nanyang App',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(28, context),
                              fontWeight: FontWeight.w800)),
                    ],
                  )
              ],
            ),
            trailing:   IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: Icon(
                isExpanded ? Ionicons.chevron_back : Ionicons.chevron_forward,
                color: Colors.white,
                size: dynamicFontSize(32, context),
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
                    Ionicons.calendar_outline,
                    color: Colors.white,
                  ),
                  selectedIcon: Icon(
                    Ionicons.calendar,
                    color: ColorTemplate.darkVistaBlue,
                  ),
                  label: Text('Kalendar', style: TextStyle(color: Colors.white))),
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
          // Expanded(
          //   child: _currentPage,
          // )
          Expanded(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: dynamicPaddingSymmetric(0, 24, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<DashboardViewmodel, String>(selector: (context, viewmodel) => viewmodel.title, builder: (context, title, child) {
                        return getTitle(context, title);
                      }),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _user.employee.shortedName!,
                                style: TextStyle(color: ColorTemplate.violetBlue, fontSize: dynamicFontSize(24, context), fontWeight: FontWeight.w600),
                              ),
                              Text(
                                _user.level == 2 ? 'Admin' : 'Super Admin',
                                style: TextStyle(color: ColorTemplate.vistaBlue, fontSize: dynamicFontSize(20, context)),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: dynamicWidth(16, context),
                          ),
                          CircleAvatar(
                            radius: dynamicWidth(32, context),
                            backgroundColor: Colors.black,
                            child: Text(
                              _user.employee.initials!,
                              style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(28, context)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(flex: 11, child: _currentPage),
            ],
          ))
        ],
      ),
    );
  }

  Widget getTitle(BuildContext context, String title){
    if (title == ""){
      return RichText(
        text: TextSpan(
          text: 'Selamat Datang, ',
          style: TextStyle(fontSize: dynamicFontSize(40, context), fontWeight: FontWeight.w800, color: ColorTemplate.violetBlue, fontFamily: 'Poppins'),
          children: <TextSpan>[
            TextSpan(
                text: _user.employee.name.split(' ')[0],
                style: TextStyle(fontSize: dynamicFontSize(40, context), fontWeight: FontWeight.w600, color: ColorTemplate.violetBlue, fontFamily: 'Poppins')),
          ],
        ),
      );
    }else{
      return Text(
        title,
        style: TextStyle(fontSize: dynamicFontSize(40, context), fontWeight: FontWeight.w800, color: ColorTemplate.violetBlue, fontFamily: 'Poppins'),
      );
    }
  }
}