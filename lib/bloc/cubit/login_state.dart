part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class Loggedin extends LoginState {}

class Loggedout extends LoginState {}
