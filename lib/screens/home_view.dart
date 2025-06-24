import 'dart:developer';

import 'package:diagnosify_app/core/services/sigletonesharedperference.dart';
import 'package:diagnosify_app/features/chat_services/manager/cubit/chat_bot_cubit.dart';
import 'package:diagnosify_app/screens/Chat_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String token = SharedPreferenceSingleton.getString('token');
    log(token);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBotCubit, ChatBotState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // title: const Text('Home View'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ));
                },
              ),
            ],
          ),
          body: const HomeViewBody(),
        );
      },
    );
  }
}

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/home.gif',
          height: 200,
          width: 300,
        ),
        const SizedBox(height: 20),
        Expanded(child: CustomGridViewHome()),
      ],
    );
  }
}

class ContainerGrid extends StatelessWidget {
  const ContainerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff048497),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Diagnosify',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Your health companion',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CustomGridViewHome extends StatelessWidget {
  const CustomGridViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        itemCount: 6, // عدل حسب عدد العناصر اللي عايز تظهر
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Handle tap event
            },
            child: const ContainerGrid(),
          );
        },
      ),
    );
  }
}
// import 'package:diagnosify_app/features/chat_services/manager/cubit/chat_bot_cubit.dart';
// import 'package:diagnosify_app/screens/Chat_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ChatBotCubit, ChatBotState>(
//       listener: (context, state) {
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             title: const Text('Diagnosify'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.chat_bubble_outline),
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => ChatScreen(),
//                   ));
//                 },
//               ),
//             ],
//           ),
//           body: const HomeViewBody(),
//         );
//       },
//     );
//   }
// }

// class HomeViewBody extends StatelessWidget {
//   const HomeViewBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         Center(
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 25,
//                   backgroundImage:
//                       AssetImage('assets/profile.jpg'), // صورة المستخدم
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Hi Ahmad', // اسم المستخدم
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 10),

//         const SizedBox(height: 10),

//         // الصورة الرئيسية
//         Center(
//           child: Image.asset(
//             'assets/home.gif',
//             height: 200,
//             width: 300,
//           ),
//         ),
//         const SizedBox(height: 20),

//         // الجريد
//         Expanded(child: CustomGridViewHome()),
//       ],
//     );
//   }
// }

// class ContainerGrid extends StatelessWidget {
//   const ContainerGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xff048497),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Welcome to Diagnosify',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Your health companion',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 12,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CustomGridViewHome extends StatelessWidget {
//   const CustomGridViewHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GridView.builder(
//         itemCount: 6,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 1.2,
//           crossAxisSpacing: 10.0,
//           mainAxisSpacing: 10.0,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               // Handle tap event
//             },
//             child: const ContainerGrid(),
//           );
//         },
//       ),
//     );
//   }
// }
