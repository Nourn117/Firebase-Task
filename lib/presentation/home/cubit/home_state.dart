import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

enum HomeStatus { loaded, loggingOut, loggedOut }

class HomeState extends Equatable {
  final HomeStatus status;
  final UserEntity user;

  const HomeState({
    required this.user,
    this.status = HomeStatus.loaded,
  });

  HomeState copyWith({
    HomeStatus? status,
    UserEntity? user,
  }) {
    return HomeState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}