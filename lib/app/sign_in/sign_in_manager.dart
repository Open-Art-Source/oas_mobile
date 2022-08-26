import 'package:flutter/foundation.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/sign_in/validators.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum EmailSignInFormType { signIn, register }

class SignInManager with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final Auth auth;
  final OasServerApis oasServerApis;

  SignInManager({
    required this.auth,
    required this.oasServerApis,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
        await oasServerApis.registerNewUser();
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register.'
        : 'Have an account? Sign in.';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String pwd) => updateWith(password: pwd);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  // Signin via Google or Facebook

  Future<UserCredential> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      isLoading = true;
      return await signInMethod();
    } catch (e) {
      isLoading = false;
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<User> signInAnonymously() async {
    final userCredential = await _signIn(auth.signInAnonymously);
    return userCredential.user!;
  }

  Future<UserCredential> signInWithGoogle() async {
    final userCredential = await _signIn(auth.signInWithGoogle);
    return userCredential;
  }
}
