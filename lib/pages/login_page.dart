import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/cubits/login_cubit/chat_cubit/chat_cubit.dart';
import 'package:my_chat_app/pages/sign_up_page.dart';
import 'package:my_chat_app/widgets/custom_button.dart';
import 'package:my_chat_app/widgets/custom_text_form_field.dart';

import '../constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../cubits/login_cubit/auth_cubit/auth_cubit.dart';
import '../cubits/login_cubit/auth_cubit/auth_state.dart';
import '../widgets/showSnackBar.dart';
import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  static String id = 'LoginPage';

  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthState>(
     listener: (context, state) {
       if(state is LoginLoadingState){
         isLoading=true;
       }
       else if(state is LoginSuccessState) {
        BlocProvider.of<ChatCubit>(context).getMessage();
         Navigator.pushReplacementNamed(context, ChatPage.id, arguments: email!);
         isLoading=false;
         showSnackBar(context, 'Welcome',
             Colors.green);
       }
       else if(state is LoginFailureState){
          showSnackBar(context, '${state.errorMessage}',
             Colors.red);
         isLoading=false;
       }
     },
      builder: (context, state) =>  ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset("assets/images/scholar.png", height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: "Pacifico"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Pacifico",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    label: "Email",
                    hintText: "enter your email",
                    onChanged: (data) {
                      email = data;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    label: "Password",
                    hintText: "enter your password",
                    onChanged: (data) {
                      password = data;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: "Sign In",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthCubit>(context).logIn(email: email!, password: password!);
                        Navigator.pushReplacementNamed(context, ChatPage.id,
                            arguments: email);
                        /* isLoading = true;

                        try {
                          await signIn();
                          showSnackBar(
                              context, 'Signed-In Successfully !', Colors.green);
                          Navigator.pushReplacementNamed(context, ChatPage.id,
                              arguments: email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(context, 'No user found for that email.',
                                Colors.red);
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(
                                context,
                                'Wrong password provided for that user.',
                                Colors.red);
                          }
                        } catch (e) {
                          showSnackBar(context, 'there was an error', Colors.red);
                        }
                        isLoading = false;*/
                      } else {}
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don\'t have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, RegisterPage.id);
                        },
                        child: Text(
                          " Sign UP",
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
