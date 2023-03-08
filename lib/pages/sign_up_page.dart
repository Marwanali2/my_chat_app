import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/constants.dart';
import 'package:my_chat_app/widgets/custom_button.dart';
import 'package:my_chat_app/widgets/custom_text_form_field.dart';

import '../cubits/login_cubit/auth_cubit/auth_cubit.dart';
import '../cubits/login_cubit/auth_cubit/auth_state.dart';
import '../widgets/showSnackBar.dart';
import 'chat_page.dart';
import 'login_page.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey(); // شرحها مكتوب في الون نوت

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthState>(
      listener: (context, state) {
        if(state is RegisterLoadingState){
          isLoading=true;
        }
        else if(state is RegisterSuccessState) {
          Navigator.pushNamed(context, LoginPage.id,arguments: email);
          showSnackBar(context, 'Signed-Up Successfully !',
              Colors.red);
          isLoading=false;
        }
        else if(state is RegisterFailureState){
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
              //علشان احقق ال form validation بشوف  الويدجت اللي عايز اتحقق منها موجوده جوا مين يعني اعمل  wrap with widget form للويدجت اللي بتحتوي علي الويدجت اللي بتحقق منها و بحدد ال key الخاص بالform
              key: formKey,
              //ال key عبارة عن مفتاح بيبقي خاص لكل فورم يعني من خلال الkey ده اقدر اوصل لمحتوي الفورم بتاعتي
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    "assets/images/scholar.png",
                    height: 100,
                  ),
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
                        'Sign UP',
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
                    onChanged: (data) {
                      password = data;
                    },
                    label: "Password",
                    hintText: "enter your password",
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: "Sign UP",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<AuthCubit>(context).registerUser(email: email!, password: password!);
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
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, LoginPage.id);
                        },
                        child: Text(
                          " Sign In",
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

  Future<void> signUp() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
