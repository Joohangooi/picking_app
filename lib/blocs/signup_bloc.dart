import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupFormSubmitted>(_onSignupFormSubmitted);
  }

  void _onSignupFormSubmitted(
    SignupFormSubmitted event,
    Emitter<SignupState> emit,
  ) {
    final isNameValid = event.name.isNotEmpty;
    final isEmailValid = event.email.isNotEmpty && event.email.contains('@');
    final isPasswordLengthValid =
        event.password.length >= 6 && event.password.length <= 15;
    final isPasswordValid = event.password.contains(RegExp(r'[0-9]')) &&
        event.password.contains(RegExp(r'[!@#$%^&+=.]'));
    final isPhoneNumValid =
        event.phoneNum.isNotEmpty && event.phoneNum.length <= 20;
    final isAddressValid = event.address.length <= 100;
    final isCompanyValid = event.company.isNotEmpty;

    if (isNameValid &&
        isEmailValid &&
        isPasswordLengthValid &&
        isPasswordValid &&
        isPhoneNumValid &&
        isAddressValid &&
        isCompanyValid) {
      emit(SignupSuccess());
    } else {
      emit(SignupFailure(
        name: isNameValid ? null : 'Please enter your username',
        email: isEmailValid ? null : 'Please enter a valid email address',
        password: (isPasswordLengthValid
                ? null
                : 'Password must be between 6 and 15 characters') ??
            (isPasswordValid
                ? null
                : 'Password must contain at least one special character. '),
        phoneNum: isPhoneNumValid
            ? null
            : 'Phone number must not be longer than 20 characters',
        address: isAddressValid
            ? null
            : 'Address should not be longer than 100 characters',
        company: isCompanyValid ? null : 'Please enter your company name',
      ));
    }
  }
}
