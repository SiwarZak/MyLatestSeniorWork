part of 'menu_drawer_cubit.dart';

abstract class MenuDrawerState {}

class MenuDrawerInitial extends MenuDrawerState {}

class MenuDrawerLoading extends MenuDrawerState {}

class MenuDrawerLoaded extends MenuDrawerState {
  final String fullName;
  final String email;

  MenuDrawerLoaded({required this.fullName, required this.email});

  @override
  List<Object?> get props => [fullName, email];
}

class MenuDrawerError extends MenuDrawerState {
  final String message;

  MenuDrawerError(this.message);

  @override
  List<Object?> get props => [message];
}