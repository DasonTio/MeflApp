import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  AuthService({
    required this.auth,
  });
  FirebaseAuth auth;
  User? user;
  
  signIn({
    required String email,
    required String password,
  }) async {
    // Start Sign In
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('There is no user registered');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided');
      }
    } catch (e) {
      print(e);
    }
    // End Sign In

    return user;
  }

  signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    // Start Sign Up
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.sendEmailVerification();
      await user!.updateDisplayName(username);
      await user!.reload();

      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided was too weak');
      } else if (e.code == 'email-already-in-user') {
        print('The account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
    // End Sign Up
    return user;
  }
}
