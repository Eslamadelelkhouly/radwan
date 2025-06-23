import 'dart:async';
import 'dart:developer';

import 'package:diagnosify_app/core/manager/get_question_cubit/get_question_cubit.dart';
import 'package:diagnosify_app/core/services/sigletonesharedperference.dart';
import 'package:diagnosify_app/features/auth/manager/logincubit/login_cubit.dart';
import 'package:diagnosify_app/features/auth/manager/signupcubit/signup_cubit.dart';
import 'package:diagnosify_app/features/chat_services/manager/cubit/chat_bot_cubit.dart';
import 'package:diagnosify_app/screens/Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceSingleton.init();

  runApp(Diagnosify_app());
}

class Diagnosify_app extends StatefulWidget {
  @override
  State<Diagnosify_app> createState() => _Diagnosify_appState();
}

class _Diagnosify_appState extends State<Diagnosify_app> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBotCubit>(
          create: (context) => ChatBotCubit(),
        ),
        BlocProvider<GetQuestionCubit>(
          create: (context) => GetQuestionCubit(),
        ),
        BlocProvider<SignupCubit>(
          create: (context) => SignupCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diagnosify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
