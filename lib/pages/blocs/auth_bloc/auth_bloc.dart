import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/pages/blocs/auth_bloc/auth_state.dart';

import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if(event is LoginEvent){
        emit(LoginLoadingState());
        try {
          var auth = FirebaseAuth.instance;
          UserCredential user = await auth.signInWithEmailAndPassword(
            email:event.email,
            password: event.password,

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
    });
  }
}
