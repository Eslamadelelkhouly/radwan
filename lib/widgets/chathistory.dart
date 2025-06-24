import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diagnosify_app/widgets/chat_session_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryButtonPage extends StatefulWidget {
  @override
  State<ChatHistoryButtonPage> createState() => _ChatHistoryButtonPageState();
}

class _ChatHistoryButtonPageState extends State<ChatHistoryButtonPage> {
  List<Map<String, dynamic>> conversations = [];

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonHistory = prefs.getStringList('chatHistory') ?? [];
    setState(() {
      conversations = jsonHistory
          .map((e) => json.decode(e) as Map<String, dynamic>)
          .toList();
    });
  }

  String formatDate(String isoDate) {
    try {
      DateTime date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "تاريخ غير معروف";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat History")),
      body: conversations.isEmpty
          ? const Center(child: Text('لا يوجد محادثات محفوظة.'))
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final sessionStart = conversation['sessionStart'] ?? 'unknown';
                final messages =
                    (conversation['messages'] ?? []) as List<dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatSessionDetailPage(
                          sessionData: conversation,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "جلسة: ${formatDate(sessionStart)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          "${messages.length} رسالة",
                          style: const TextStyle(fontSize: 14),
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
