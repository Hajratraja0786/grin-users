import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/user_list_viewmodel.dart';
import '../widgets/user_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserListViewModel>().fetchInitial();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final vm = context.read<UserListViewModel>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200 &&
        vm.loadMoreError == null) {
      vm.loadMore();
    }
  }

  void _loadIfNotScrollable(UserListViewModel vm) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      if (_controller.position.maxScrollExtent <= 0 &&
          vm.hasMore &&
          !vm.isLoading &&
          !vm.isLoadingMore &&
          vm.loadMoreError == null) {
        vm.loadMore();
      }
    });
  }

  Future<void> _onRefresh(UserListViewModel vm) async {
    await vm.fetchInitial(isRefresh: true);
    if (vm.error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(vm.error!)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grin Users'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthViewModel>().logout(),
          ),
        ],
      ),
      body: Consumer<UserListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      vm.error != null ? Icons.error_outline : Icons.inbox,
                      size: 56,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vm.error ?? 'No users found',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: vm.fetchInitial,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          _loadIfNotScrollable(vm);

          final showFooter = vm.isLoadingMore || vm.loadMoreError != null;
          return RefreshIndicator(
            onRefresh: () => _onRefresh(vm),
            child: ListView.builder(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: vm.users.length + (showFooter ? 1 : 0),
              itemBuilder: (context, i) {
                if (i < vm.users.length) return UserCard(user: vm.users[i]);
                if (vm.isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(vm.loadMoreError!),
                      TextButton(
                        onPressed: vm.loadMore,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}