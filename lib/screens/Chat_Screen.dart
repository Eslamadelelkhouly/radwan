import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:diagnosify_app/features/chat_services/manager/cubit/chat_bot_cubit.dart';
import 'package:diagnosify_app/screens/Login_Screen.dart';
import 'package:diagnosify_app/screens/ProfileForm.dart';
import 'package:diagnosify_app/widgets/chathistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.imagePath,
  });

  XFile? get imageFile => imagePath != null ? XFile(imagePath!) : null;

  Map<String, dynamic> toJson() => {
        'text': text,
        'isMe': isMe,
        'imagePath': imagePath,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isMe: json['isMe'],
        imagePath: json['imagePath'],
      );
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isFirstMessageSent = false;
  final ImagePicker _picker = ImagePicker();
  late String sendmessage;
  bool _isLoading = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonMessages =
        messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList('chatMessages', jsonMessages);
  }

  Future<void> addToChatHistory(ChatMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('chatHistory') ?? [];
    history.add(jsonEncode(message.toJson()));
    await prefs.setStringList('chatHistory', history);
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonMessages = prefs.getStringList('chatMessages');
    if (jsonMessages != null) {
      setState(() {
        messages.clear();
        messages.addAll(jsonMessages
            .map((json) => ChatMessage.fromJson(jsonDecode(json)))
            .toList());
        _isFirstMessageSent = messages.isNotEmpty;
      });
    }
  }

  Future<void> clearChatMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatMessages');
  }

  Future<bool> showExitConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('الخروج من المحادثة'),
            content: const Text('هل تريد حفظ المحادثة قبل الخروج؟'),
            actions: [
              TextButton(
                child: const Text('نعم، احتفظ بها'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextButton(
                child: const Text('لا، امسحها'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ) ??
        true;
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      final userMessage = ChatMessage(text: message, isMe: true);
      setState(() {
        messages.add(userMessage);
        _controller.clear();
        _isFirstMessageSent = true;
        _isLoading = true;
      });
      await saveMessages(messages);
      await addToChatHistory(userMessage);
      context.read<ChatBotCubit>().getChatResponse(message: message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
    }
  }

  void _sendImage(XFile imageFile) async {
    final imageMessage = ChatMessage(
      text: '',
      isMe: true,
      imagePath: imageFile.path,
    );
    setState(() {
      messages.add(imageMessage);
      _isFirstMessageSent = true;
    });
    await saveMessages(messages);
    await addToChatHistory(imageMessage);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendImage(pickedFile);
    }
  }

  void _startNewConversation() async {
    setState(() {
      messages.clear();
      _isFirstMessageSent = false;
      _isLoading = false;
    });
    await clearChatMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool keep = await showExitConfirmation();
        if (!keep) await clearChatMessages();
        return true;
      },
      child: BlocConsumer<ChatBotCubit, ChatBotState>(
        listener: (context, state) async {
          if (state is ChatBotLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is ChatbotSucess) {
            final botMessage =
                ChatMessage(text: state.response['response'], isMe: false);
            setState(() {
              messages.add(botMessage);
              _isLoading = false;
            });
            await saveMessages(messages);
            await addToChatHistory(botMessage);
          } else if (state is ChatbotError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat'),
              automaticallyImplyLeading: false,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _startNewConversation,
                ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  bool keep = await showExitConfirmation();
                  if (!keep) await clearChatMessages();
                  Navigator.of(context).pop();
                },
              ),
            ),
            drawer: ModalProgressHUD(
              inAsyncCall: _isLoading,
              progressIndicator:
                  const CircularProgressIndicator(color: Color(0xff048497)),
              child: Drawer(
                child: ListView(
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xff048497)),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle_outlined, size: 40),
                          SizedBox(width: 8.0),
                          Text('Good Morning, Lara',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('Profile'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilePage()),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Chat history'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatHistoryButtonPage()),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 300.0)),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length + (_isFirstMessageSent ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (!_isFirstMessageSent && index == 0) {
                        return Center(
                          child: Image.asset(
                            'assets/IMG-20250226-WA0010-removebg-preview.png',
                            width: 400,
                            height: 800,
                          ),
                        );
                      } else {
                        final msg =
                            messages[_isFirstMessageSent ? index : index - 1];
                        return Align(
                          alignment: msg.isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: msg.isMe
                                  ? const Color(0xff048497)
                                  : Colors.grey[300],
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
                                        color: msg.isMe
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.perm_media_outlined),
                        onPressed: _pickImage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on_outlined),
                        onPressed: _launchMap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> _launchMap() async {
  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/Hospitals+and+clinics/@31.0095244,31.3760457,13z',
  );
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
