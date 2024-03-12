part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupFormSubmitted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNum;
  final String address;
  final String company;

  const SignupFormSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNum,
    required this.address,
    required this.company,
  });

  @override
  List<Object> get props => [name, email, password, phoneNum, address, company];
}

class TriggerSignupFailure extends SignupEvent {
  final String errorMessage;

  const TriggerSignupFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
