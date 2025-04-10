abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  String errorMessage;

  LoginErrorState(this.errorMessage);
}

class ResetPasswordSuccessState extends LoginStates {}

class ResetPasswordFaildState extends LoginStates {
  String errorMessage;

  ResetPasswordFaildState(this.errorMessage);
}
