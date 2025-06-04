import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/cubit/theme_cubit.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _skip = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bloc.cachedUsers.isEmpty) {
        bloc.add(const FetchUsers(isInitial: true));
      } else {
        bloc.add(const ResetUsers());
        bloc.add(const FetchUsers(isInitial: true));
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _searchQuery.isEmpty) {
        bloc.add(LoadMoreUsers(skip: bloc.skip));
      }
    });
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _skip = 0;
    if (query.isEmpty) {
      context.read<UserBloc>().add(const FetchUsers());
    } else {
      context.read<UserBloc>().add(SearchUsers(query));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Hive', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading && _skip == 0) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserBloc>().add(const ResetUsers());
                      context.read<UserBloc>().add(
                        const FetchUsers(isInitial: true),
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(user.image),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.email),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/user_detail',
                              arguments: user,
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is UserError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: const SizedBox(child: Text("Some Issue")));
              },
            ),
          ),
        ],
      ),
    );
  }
}
