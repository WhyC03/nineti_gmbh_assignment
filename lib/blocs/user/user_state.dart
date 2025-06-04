import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedEnd;

  const UserLoaded(this.users, {this.hasReachedEnd = false});

  @override
  List<Object?> get props => [users, hasReachedEnd];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserDetailLoaded extends UserState {
  final User user;
  final List<Post> posts;
  final List<Todo> todos;

  const UserDetailLoaded({required this.user, required this.posts, required this.todos});

  @override
  List<Object?> get props => [user, posts, todos];
}