import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nanyang_application_desktop/module/splash_screen.dart';
import 'package:nanyang_application_desktop/provider/color_provider.dart';
import 'package:nanyang_application_desktop/provider/configuration_provider.dart';
import 'package:nanyang_application_desktop/provider/date_provider.dart';
import 'package:nanyang_application_desktop/provider/file_provider.dart';
import 'package:nanyang_application_desktop/provider/toast_provider.dart';
import 'package:nanyang_application_desktop/service/announcement_service.dart';
import 'package:nanyang_application_desktop/service/attendance_service.dart';
import 'package:nanyang_application_desktop/service/auth_service.dart';
import 'package:nanyang_application_desktop/service/chat_service.dart';
import 'package:nanyang_application_desktop/service/employee_service.dart';
import 'package:nanyang_application_desktop/service/firebase_service.dart';
import 'package:nanyang_application_desktop/service/request_service.dart';
import 'package:nanyang_application_desktop/service/user_service.dart';
import 'package:nanyang_application_desktop/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/chat_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/date_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/request_viewmodel.dart';
import 'package:nanyang_application_desktop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseService().initNotification();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      title: 'Nanyang App',
      size: Size(1024, 640),
      minimumSize: Size(1024, 640),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAspectRatio(1024 / 640);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(authenticationService: AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(userService: UserService()),
        ),
        ChangeNotifierProvider(
          create: (context) => EmployeeViewModel(employeeService: EmployeeService()),
        ),
        ChangeNotifierProvider(
          create: (context) => AnnouncementViewModel(announcementService: AnnouncementService()),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestViewModel(requestService: RequestService()),
        ),
        ChangeNotifierProvider(
          create: (context) => AttendanceViewModel(attendanceService: AttendanceService()),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(chatService: ChatService()),
        ),
        ChangeNotifierProvider(
          create: (context) => DateViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfigurationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToastProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FileProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return FToastBuilder()(context, child);
        },
        title: 'Nanyang Mobile',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
              overlayColor: MaterialStateProperty.all(Colors.blue),
            ),
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      ),
    ),
  );
}
