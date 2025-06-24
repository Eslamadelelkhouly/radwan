import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryButtonPage extends StatefulWidget {
  @override
  State<ChatHistoryButtonPage> createState() => _ChatHistoryButtonPageState();
}

class _ChatHistoryButtonPageState extends State<ChatHistoryButtonPage> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonHistory = prefs.getStringList('chatHistory') ?? [];
    setState(() {
      history = jsonHistory
          .map((e) => json.decode(e) as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat History")),
      body: history.isEmpty
          ? Center(child: Text('No chat history yet.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final bool isMe = item['isMe'];
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (item['imagePath'] != null)
                          Image.file(
                            File(item['imagePath']),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        if (item['text'] != null && item['text'] != "")
                          Text(
                            item['text'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
