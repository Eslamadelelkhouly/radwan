import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.imagePath,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isMe: json['isMe'],
        imagePath: json['imagePath'],
      );
}

class ChatSessionDetailPage extends StatelessWidget {
  final Map<String, dynamic> sessionData;

  const ChatSessionDetailPage({Key? key, required this.sessionData})
      : super(key: key);

  List<ChatMessage> getMessages() {
    List<dynamic> messagesJson = sessionData['messages'] ?? [];
    return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final messages = getMessages();
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الجلسة'),
      ),
      body: messages.isEmpty
          ? const Center(child: Text('No messages in this session.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                      msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: msg.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (msg.imagePath != null)
                          Image.file(
                            File(msg.imagePath!),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        if (msg.text.isNotEmpty)
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isMe ? Colors.white : Colors.black,
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
