import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:oas_mobile/app/services/auth.dart';

class SignInManagerOld {
  final Auth auth;
  final ValueNotifier<bool> isLoading;

  SignInManagerOld({required this.isLoading, required this.auth});

  Future<UserCredential> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
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