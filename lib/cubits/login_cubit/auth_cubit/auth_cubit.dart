import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  Future<void> registerUser({required String email,required String password}) async {
    emit(RegisterLoadingState());
    try {
      var auth = FirebaseAuth.instance;
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      emit(RegisterSuccessState());
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailureState(errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailureState(errorMessage: 'The account already exists for that email.'));
      }
    }

    on Exception catch (e) {
      emit(RegisterFailureState(errorMessage: 'Some thing went wrong '));
    }
  }



  Future<void> logIn({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      var auth = FirebaseAuth.instance;
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,

      );

      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailureState(errorMessage: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailureState(errorMessage: 'wrong-password'));
      }
    } on Exception catch (e) {
      emit(LoginFailureState(errorMessage: 'Some thing went wrong '));
    }
  }



}
