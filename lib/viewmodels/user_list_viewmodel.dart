import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserListViewModel extends ChangeNotifier {
  final UserRepository _repo;
  UserListViewModel(this._repo);

  final List<UserModel> _users = [];
  int _page = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _loadMoreError;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String? get loadMoreError => _loadMoreError;
  bool get hasMore => _page < _totalPages;


  Future<void> fetchInitial({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }
    _error = null;
    _loadMoreError = null;
    try {
      final res = await _repo.getUsers(page: 1);
      _users
        ..clear()
        ..addAll(res.users);
      _page = res.page;
      _totalPages = res.totalPages;
    } catch (e) {
      _error = _clean(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Next page (scroll pagination)
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !hasMore) return;
    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();
    try {
      final res = await _repo.getUsers(page: _page + 1);
      _users.addAll(res.users);
      _page = res.page;
      _totalPages = res.totalPages;
    } catch (e) {
      _loadMoreError = _clean(e);
    }
    _isLoadingMore = false;
    notifyListeners();
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}