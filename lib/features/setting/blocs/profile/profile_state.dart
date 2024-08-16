part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

class ProfileState extends Equatable {
  const ProfileState({
    required this.user,
    required this.message,
    required this.status,
  });

  factory ProfileState.initial() => ProfileState(
        user: User.initial(),
        status: ProfileStatus.initial,
        message: '',
      );

  final User user;
  final String message;
  final ProfileStatus status;

  @override
  List<Object?> get props => [user, message, status];

  ProfileState copyWith({
    User? user,
    String? message,
    ProfileStatus? status,
  }) {
    return ProfileState(
      user: user ?? this.user,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}
