part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String? name;
  final String? email;
  final String? password;
  final String? phoneNum;
  final String? address;
  final String? company;
  final String? emailDuplicateError;

  const SignupFailure(
      {this.name,
      this.email,
      this.password,
      this.phoneNum,
      this.address,
      this.company,
      this.emailDuplicateError});

  @override
  List<Object> get props => [
        name ?? '',
        email ?? '',
        password ?? '',
        phoneNum ?? '',
        address ?? '',
        company ?? ''
      ];
}
