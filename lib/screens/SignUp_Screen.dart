import 'package:diagnosify_app/core/services/sigletonesharedperference.dart';
import 'package:diagnosify_app/features/auth/data/model/signup_error_model.dart';
import 'package:diagnosify_app/features/auth/manager/signupcubit/signup_cubit.dart';
import 'package:diagnosify_app/screens/HealthQuestionnaireScreen.dart';
import 'package:diagnosify_app/screens/Login_Screen.dart';
import 'package:diagnosify_app/screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String Fname,
      LName,
      nationalID,
      phoneNumber,
      email,
      password,
      confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignupErrorModel signupErrorModel = SignupErrorModel(
    fName: [],
    lName: [],
    nationailNumber: [],
    phoneNumber: [],
    email: [],
    password: [],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) async {
          if (state is SignupSuccess) {
            print(
                '✅ Signup successful. Access token: ${state.signUpModel.accessToken}');

            // Save token
            await SharedPreferenceSingleton.setString(
              'token',
              state.signUpModel.accessToken,
            );

            // Optional: read back token
            final savedToken =
                await SharedPreferenceSingleton.getString('token');
            print('🔐 Saved token: $savedToken');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()),
            );
          } else if (state is SignupError) {
            signupErrorModel = SignupErrorModel.fromJson(state.errorMessage);
            setState(() {}); // to refresh errors
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is SignupLoading,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Create\nAccount',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        buildTextField(
                          label: 'First Name',
                          hint: 'Enter Your Name',
                          errorText: signupErrorModel.fName,
                          onSaved: (val) => Fname = val!,
                        ),
                        buildTextField(
                          label: 'Last Name',
                          hint: 'Enter Your Last Name',
                          errorText: signupErrorModel.lName,
                          onSaved: (val) => LName = val!,
                        ),
                        buildTextField(
                          label: 'National ID',
                          hint: 'Enter Your National ID',
                          errorText: signupErrorModel.nationailNumber,
                          onSaved: (val) => nationalID = val!,
                        ),
                        buildTextField(
                          label: 'Phone Number',
                          hint: 'Enter Your Phone Number',
                          errorText: signupErrorModel.phoneNumber,
                          onSaved: (val) => phoneNumber = val!,
                        ),
                        buildTextField(
                          label: 'Email',
                          hint: 'Enter Your Email',
                          errorText: signupErrorModel.email,
                          onSaved: (val) => email = val!,
                        ),
                        buildTextField(
                          label: 'Password',
                          hint: 'Enter Your Password',
                          isPassword: true,
                          errorText: signupErrorModel.password,
                          onSaved: (val) => password = val!,
                        ),
                        buildTextField(
                          label: 'Confirm Your Password',
                          hint: 'Enter Your Password Again',
                          isPassword: true,
                          onSaved: (val) => confirmPassword = val!,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (_) {}),
                            const Text('I agree to the Terms and Conditions'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              context.read<SignupCubit>().Signupmethodcubit(
                                    FName: Fname,
                                    LName: LName,
                                    nationalid: nationalID,
                                    phoneNumber: phoneNumber,
                                    email: email,
                                    password: password,
                                    password_confirmation: confirmPassword,
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff048497),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Sign Up',
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Do you have an account? ',
                                  style: TextStyle(color: Colors.black)),
                              Text(' Sign in',
                                  style: TextStyle(color: Color(0xff048497))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hint,
    List<String>? errorText,
    bool isPassword = false,
    required Function(String?) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
          onSaved: onSaved,
        ),
        const SizedBox(height: 10),
        if (errorText != null && errorText.isNotEmpty)
          Text(errorText[0], style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 20),
      ],
    );
  }
}
