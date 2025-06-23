// import 'package:diagnosify_app/screens/Chat_Screen.dart';
import 'package:diagnosify_app/core/services/sigletonesharedperference.dart';
import 'package:diagnosify_app/features/auth/data/model/login_error_model.dart';
import 'package:diagnosify_app/features/auth/manager/logincubit/login_cubit.dart';
import 'package:diagnosify_app/screens/ForgotPassword.dart';
import 'package:diagnosify_app/screens/SignUp_Screen.dart';
import 'package:diagnosify_app/screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  LoginErrorModel loginErrorModel = LoginErrorModel(
    email: [],
    password: [],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ('✅ Login successful. Access token: ${state.loginSuccessModel.accessToken}');
              SharedPreferenceSingleton.setString(
                'token',
                state.loginSuccessModel.accessToken,
              );
              final savedToken = SharedPreferenceSingleton.getString('token');
              print('🔐 Saved token: $savedToken');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            } else if (state is LoginError) {
              print('❌ Login failed: ${state.errorMessage.toString()}');
              loginErrorModel = LoginErrorModel.fromJson(state.errorMessage);
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is LoginLoading,
              child: Form(
                key: widget.formKey,
                child: Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Welcome\nBack!',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    TextFormField(
                      onSaved: (val) => email = val!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Please Enter Your Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Text(
                      loginErrorModel.email?.isNotEmpty == true
                          ? loginErrorModel.email![0]
                          : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onSaved: (val) => password = val!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Please Enter Your Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Text(
                      loginErrorModel.password?.isNotEmpty == true
                          ? loginErrorModel.password![0]
                          : '',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                        // Navigate to forgot password screen
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Forgot Password? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            ' Click Here',
                            style: TextStyle(color: Color(0xff048497)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.formKey.currentState!.validate()) {
                          widget.formKey.currentState!.save();
                          context.read<LoginCubit>().loginMethodCubit(
                                email: email,
                                password: password,
                              );
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff048497),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                        // Navigate to sign up screen
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account? ',
                              style: TextStyle(color: Colors.black)),
                          Text(' Sign UP',
                              style: TextStyle(color: Color(0xff048497))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
