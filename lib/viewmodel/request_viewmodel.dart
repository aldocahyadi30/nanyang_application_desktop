import 'package:flutter/material.dart';
import 'package:nanyang_application_desktop/main.dart';
import 'package:nanyang_application_desktop/model/request.dart';
import 'package:nanyang_application_desktop/provider/toast_provider.dart';
import 'package:nanyang_application_desktop/service/navigation_service.dart';
import 'package:nanyang_application_desktop/service/request_service.dart';
import 'package:nanyang_application_desktop/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestViewModel extends ChangeNotifier {
  final RequestService _requestService;
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final ConfigurationViewModel _configViewModel =
      Provider.of<ConfigurationViewModel>(navigatorKey.currentContext!, listen: false);
  List<RequestModel> _request = [];
  List<RequestModel> _requestDashboard = [];
  RequestModel _selectedRequest = RequestModel.empty();
  List<int> _filterCategory = [];
  String filterStatus = 'Pending';
  DateTimeRange? filterDate;
  int currentPage = 0;

  RequestViewModel({required RequestService requestService}) : _requestService = requestService;

  int get currentPageIndex => currentPage;

  set currentPageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  get request {
    List<RequestModel> requestFiltered = _request;

    if (filterStatus == '') {
      requestFiltered = requestFiltered
          .where((element) =>
              element.approver!.id == 0 ||
              element.rejecter!.id == 0 ||
              element.approver!.id != 0 ||
              element.rejecter!.id != 0)
          .toList();
    } else {
      if (filterStatus == 'Pending') {
        requestFiltered =
            requestFiltered.where((element) => element.approver!.id == 0 && element.rejecter!.id == 0).toList();
      }

      if (filterStatus == 'Approved') {
        requestFiltered = requestFiltered.where((element) => element.approver!.id != 0).toList();
      }

      if (filterStatus == 'Rejected') {
        requestFiltered = requestFiltered.where((element) => element.rejecter!.id != 0).toList();
      }
    }

    if (_filterCategory.isNotEmpty) {
      requestFiltered = requestFiltered.where((element) => _filterCategory.contains(element.type)).toList();
    }

    if (filterDate != null) {
      requestFiltered = requestFiltered.where((element) {
        return element.startDateTime!.isAfter(filterDate!.start) && element.startDateTime!.isBefore(filterDate!.end);
      }).toList();
    }

    return requestFiltered;
  }

  get requestPending {
    return _request.where((element) => element.approver!.id == 0 && element.rejecter!.id == 0).toList();
  }

  get requestDashboard => _requestDashboard;

  RequestModel get selectedRequest => _selectedRequest;

  void setSelectedRequest(RequestModel model) {
    _selectedRequest = model;
    notifyListeners();
  }

  Future<void> getDashboardRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getDashboardRequest(_configViewModel.user.level,
          employeeID: _configViewModel.user.isAdmin ? null : _configViewModel.user.employee.id);

      _requestDashboard = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get dashboard error: ${e.message}');
      } else {
        debugPrint('Request get dashboard error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getListRequest(
          employeeID: _configViewModel.user.isAdmin ? null : _configViewModel.user.employee.id);
      _request = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get list error: ${e.message}');
      } else {
        debugPrint('Request get list error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> response(String type) async {
    try {
      if (type == 'approve') {
        selectedRequest.approver = _configViewModel.user.employee;
        await _requestService.approve(selectedRequest);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(
          content: Text('Permintaan berhasil disetujui!'),
          backgroundColor: Colors.green,
        ));
      } else {
        selectedRequest.rejecter = _configViewModel.user.employee;
        await _requestService.reject(selectedRequest);
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(
          content: Text('Permintaan berhasil ditolak!'),
          backgroundColor: Colors.red,
        ));
      }

      await index();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request response error: ${e.message}');
      } else {
        debugPrint('Request response error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(
        content: Text('Terjadi kesalahan, silahkan coba lagi!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void addFilter({List<int>? selectedCategory, String? status, DateTimeRange? date}) {
    if (selectedCategory != null) {
      _filterCategory = selectedCategory;
    } else {
      _filterCategory = [];
    }
    if (status != null) {
      filterStatus = status;
    } else {
      filterStatus = 'Pending';
    }
    if (date != null) {
      filterDate = date;
    } else {
      filterDate = null;
    }
    notifyListeners();
  }

  // void edit(RequestModel model) {
  //
  //   _selectedRequest = model;
  //   _navigationService.navigateTo(RequestFormScreen(type: model.type));
  // }

  Future<void> delete(int id) async {
    try {
      await _requestService.delete(id).then((_) {
        getRequest();
        _toastProvider.showToast('Permintaan berhasil dihapus!', 'success');
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request delete error: ${e.message}');
      } else {
        debugPrint('Request delete error: ${e.toString()}');
      }
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(const SnackBar(
        content: Text('Terjadi kesalahan, silahkan coba lagi!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> index() async {
    currentPageIndex = 0;
    addFilter();
    await getRequest();
  }

  void detail(RequestModel model) {
    _selectedRequest = model;
    currentPageIndex = 1;
  }
}