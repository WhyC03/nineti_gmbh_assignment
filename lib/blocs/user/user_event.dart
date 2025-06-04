import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isInitial;

  const FetchUsers({this.isInitial = false});

  @override
  List<Object?> get props => [isInitial];
}

class ResetUsers extends UserEvent {
  const ResetUsers();
}


class SearchUsers extends UserEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreUsers extends UserEvent {
  final int skip;

  const LoadMoreUsers({required this.skip});

  @override
  List<Object?> get props => [skip];
}

class FetchUserDetails extends UserEvent {
  final int userId;

  const FetchUserDetails(this.userId);

  @override
  List<Object?> get props => [userId];
}
