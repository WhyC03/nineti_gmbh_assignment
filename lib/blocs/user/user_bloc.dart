import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/models/user_model.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  int skip = 0;
  final int limit = 10;
  bool isFetching = false;
  List<User> cachedUsers = [];
  bool hasReachedEnd = false;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<FetchUserDetails>(_onFetchUserDetails);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<ResetUsers>(_onResetUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (event.isInitial || cachedUsers.isEmpty) {
        skip = 0;
        emit(UserLoading());
        final users = await userRepository.fetchUsers(limit: limit, skip: skip);
        skip += limit;

        cachedUsers = users;
        hasReachedEnd = users.length < limit;

        emit(UserLoaded(cachedUsers, hasReachedEnd: hasReachedEnd));
      } else {
        emit(UserLoaded(cachedUsers, hasReachedEnd: hasReachedEnd));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await userRepository.fetchUsers(search: event.query);
      emit(UserLoaded(users, hasReachedEnd: true));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await userRepository.fetchUsers();
      final user = users.firstWhere((u) => u.id == event.userId);
      final posts = await userRepository.fetchPosts(event.userId);
      final todos = await userRepository.fetchTodos(event.userId);
      emit(UserDetailLoaded(user: user, posts: posts, todos: todos));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (isFetching || hasReachedEnd || state is! UserLoaded) return;
    isFetching = true;

    try {
      final newUsers = await userRepository.fetchUsers(
        limit: limit,
        skip: event.skip,
      );
      skip += limit;
      cachedUsers.addAll(newUsers);
      hasReachedEnd = newUsers.length < limit;

      emit(UserLoaded(List.from(cachedUsers), hasReachedEnd: hasReachedEnd));
    } catch (e) {
      emit(UserError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  void _onResetUsers(ResetUsers event, Emitter<UserState> emit) {
    cachedUsers.clear();
    skip = 0;
    emit(UserInitial());
  }
}
