import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/announcement.dart';
import 'package:nanyang_application_desktop/model/announcement_category.dart';
import 'package:nanyang_application_desktop/service/announcement_service.dart';
import 'package:nanyang_application_desktop/service/navigation_service.dart';
import 'package:nanyang_application_desktop/viewmodel/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _announcementService;
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  List<AnnouncementModel> _announcement = [];
  List<AnnouncementModel> _announcementDashboard = [];
  List<AnnouncementCategoryModel> _announcementCategory = [];
  AnnouncementModel _selectedAnnouncement = AnnouncementModel.empty();
  List<int> selectedCategory = [];
  int currentPage = 0;
  int _filterCategory = 0;

  AnnouncementViewModel({required AnnouncementService announcementService})
      : _announcementService = announcementService;

  get announcement => _announcement;

  get announcementDashboard => _announcementDashboard;

  get announcementCategory => _announcementCategory;

  AnnouncementModel get selectedAnnouncement => _selectedAnnouncement;

  int get currentPageIndex => currentPage;

  int get filterCategory => _filterCategory;

  set selectedAnnouncement(AnnouncementModel model) {
    _selectedAnnouncement = model;
    notifyListeners();
  }

  set currentPageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  set filterCategory(int category) {
    _filterCategory = category;
    notifyListeners();
  }

  Future<void> getDashboardAnnouncement() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getDashboardAnnouncement();
      _announcementDashboard = AnnouncementModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get dashboard error: ${e.message}');
      } else {
        debugPrint('Announcement get dashboard error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> getAnnouncement({List<int> categoryID = const []}) async {
    try {
      List<Map<String, dynamic>> data = [];
      if (categoryID.isEmpty) {
        data = await _announcementService.getAnnouncement();
      } else {
        data = await _announcementService.getAnnouncementByCategory(categoryID);
      }
      _announcement = AnnouncementModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get error: ${e.message}');
      } else {
        debugPrint('Announcement get error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> getAnnouncementCategory() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getAnnouncementCategory();
      _announcementCategory = AnnouncementCategoryModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get category error: ${e.message}');
      } else {
        debugPrint('Announcement get category error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> storeAnnouncementCategory(String title, String color) async {
    try {
      await _announcementService.storeAnnouncementCategory(title, color);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Berhasil menambahkan kategori pengumuman!'), backgroundColor: Colors.green));

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store category error: ${e.message}');
      } else {
        debugPrint('Announcement store category error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> updateAnnouncementCategory(AnnouncementCategoryModel model, String title, String color) async {
    try {
      await _announcementService.updateAnnouncementCategory(model.id, title, color);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Berhasil mengubah kategori pengumuman!'), backgroundColor: Colors.green));

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement update category error: ${e.message}');
      } else {
        debugPrint('Announcement update catgeory error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> index() async {
    currentPageIndex = 0;
    filterCategory = 0;
    await getAnnouncement();
    navigatorKey.currentContext!.read<DashboardViewmodel>().title = 'Pengumuman';
  }

  Future<void> create() async {
    currentPageIndex = 1;
    _selectedAnnouncement = AnnouncementModel.empty();
    await navigatorKey.currentContext!.read<AnnouncementViewModel>().getAnnouncementCategory();
  }

  Future<void> store(AnnouncementModel model) async {
    try {
      await _announcementService.storeAnnouncement(model).then((_) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Berhasil menambahkan pengumuman!'), backgroundColor: Colors.green));
        getAnnouncement();
        _navigationService.goBack();
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store error: ${e.message}');
      } else {
        debugPrint('Announcement store error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  void detail(AnnouncementModel model) {
    currentPageIndex = 2;
    _selectedAnnouncement = model;
  }

  Future<void> edit(AnnouncementModel model) async {
    currentPageIndex = 1;
    _selectedAnnouncement = model;
    await navigatorKey.currentContext!.read<AnnouncementViewModel>().getAnnouncementCategory();
  }

  Future<void> update(AnnouncementModel model) async {
    try {
      await _announcementService.updateAnnouncement(model).then((_) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Berhasil mengubah pengumuman!'), backgroundColor: Colors.green));
        getAnnouncement();
        _navigationService.goBack();
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store error: ${e.message}');
      } else {
        debugPrint('Announcement store error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, silahkan coba lagi!'), backgroundColor: Colors.red));
    }
  }

  Future<void> delete(int id) async {
    await _announcementService.deleteAnnouncement(id);
    ScaffoldMessenger.of(navigatorKey.currentContext!)
        .showSnackBar(const SnackBar(content: Text('Berhasil menghapus pewngumuman!'), backgroundColor: Colors.green));
    await getAnnouncement();
  }
}