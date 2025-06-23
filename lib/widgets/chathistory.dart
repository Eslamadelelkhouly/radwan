// import 'package:flutter/material.dart';

// class ChatHistoryScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat History'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Chat 1'),
//             subtitle: Text('Last message: Hello!'),
//           ),
//           ListTile(
//             title: Text('Chat 2'),
//             subtitle: Text('Last message: How are you?'),
//           ),
//           ListTile(
//             title: Text('Chat 3'),
//             subtitle: Text('Last message: See you later!'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryButtonPage extends StatefulWidget {
  @override
  State<ChatHistoryButtonPage> createState() => _ChatHistoryButtonPageState();
}

class _ChatHistoryButtonPageState extends State<ChatHistoryButtonPage> {
  int clickCount = 0;

  @override
  void initState() {
    super.initState();
    loadClickData();
  }

  Future<void> loadClickData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCount = prefs.getInt('chatHistoryClicks') ?? 0;
    });
  }

  Future<void> recordClick() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCount++;
    });
    await prefs.setInt('chatHistoryClicks', clickCount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat history clicked $clickCount times')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF6FD),
      appBar: AppBar(title: Text("Chat History" )),
      body: Center(
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: Colors.transparent,
          ),
          onPressed: recordClick,
          icon: Icon(Icons.history, color: Colors.black),
          label: Text(
            "Chat history",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
