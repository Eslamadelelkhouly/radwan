import 'dart:developer';

import 'package:diagnosify_app/features/chat_services/manager/cubit/chat_bot_cubit.dart';
import 'package:diagnosify_app/screens/Login_Screen.dart';
import 'package:diagnosify_app/screens/ProfileForm.dart';
import 'package:diagnosify_app/widgets/chathistory.dart';
import 'package:diagnosify_app/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // For image selection
import 'dart:io';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart'; // For handling File objects

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final XFile? imageFile; // Support for XFile (image)

  const ChatMessage({
    required this.text,
    required this.isMe,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        padding: const EdgeInsets.all(
          12.0,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(
                  0xff048497,
                )
              : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 12.0 : 0),
            topRight: Radius.circular(isMe ? 0 : 12.0),
            bottomLeft: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imageFile != null) // Display the image if it exists
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Image.file(
                  File(imageFile!.path), // Convert XFile to File
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (text.isNotEmpty) // Display the text if it exists
              Text(
                text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = []; // List of messages
  final TextEditingController _controller = TextEditingController();
  bool _isFirstMessageSent =
      false; // Flag to track if the first message is sent
  final ImagePicker _picker = ImagePicker(); // For image selection
  late String sendmessage; // Variable to store the message
  bool _isLoading = false; // Track loading state
  FocusNode _focusNode =
      FocusNode(); // Focus node to control keyboard visibility

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          text: message,
          isMe: true,
        ));
        _controller.clear();
        _isFirstMessageSent = true;
        _isLoading = true; // Show loading spinner
      });
      log('Message Sent: $message');
      context.read<ChatBotCubit>().getChatResponse(message: message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
    }
  }

  void _sendImage(XFile imageFile) {
    setState(() {
      messages.add(ChatMessage(
        text: '',
        // No text, only image
        isMe: true,
        imageFile: imageFile,
      ));
      _isFirstMessageSent =
          true; // Set the flag to true after the first message is sent
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Pick image from gallery
    if (pickedFile != null) {
      _sendImage(pickedFile); // Send the image
    }
  }

  void _startNewConversation() {
    setState(() {
      messages.clear(); // Clear all messages
      _isFirstMessageSent = false; // Reset the flag
      _isLoading = false; // Reset loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBotCubit, ChatBotState>(
      listener: (context, state) {
        if (state is ChatBotLoading) {
          setState(() {
            _isLoading = true; // Show loading spinner
          });
        } else if (state is ChatbotSucess) {
          setState(() {
            messages.add(ChatMessage(
              text: state.response['response'],
              isMe: false,
            ));
            _isLoading = false; // Hide loading spinner
          });
        } else if (state is ChatbotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
          setState(() {
            _isLoading = false; // Hide loading spinner
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            automaticallyImplyLeading: false, // Remove the back button
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu), // Button to open the drawer
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the drawer
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add), // New conversation button
                onPressed: _startNewConversation,
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Custom back button behavior
                Navigator.of(context).pop();
              },
            ),
          ),
          drawer: ModalProgressHUD(
            inAsyncCall:
                _isLoading, // Show loading indicator if _isLoading is true
            progressIndicator: const CircularProgressIndicator(
              color: Color(0xff048497),
            ),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                        ),
                        Padding(padding: const EdgeInsets.all(8.0)),
                        SizedBox(height: 8.0),
                        Text('Good Morning, Lara',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff048497),
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                        ),
                        title: const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.history,
                          size: 40,
                        ),
                        title: const Text(
                          'Chat history',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatHistoryButtonPage()),
                          );
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 300.0)),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          size: 40,
                        ),
                        title: const Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                    ],
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
                  itemCount: messages.length +
                      (_isFirstMessageSent
                          ? 0
                          : 1), // Add 1 for the image if no message is sent
                  itemBuilder: (context, index) {
                    if (!_isFirstMessageSent && index == 0) {
                      return Center(
                        child: Image.asset(
                          'assets/IMG-20250226-WA0010-removebg-preview.png', // Replace with your image path
                          width: 400,
                          height: 800,
                        ),
                      );
                    } else {
                      return messages[_isFirstMessageSent ? index : index - 1];
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
                        focusNode: _focusNode, // Attach the focus node
                        onSaved: (value) {
                          sendmessage = value!;
                        },
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                        ),
                        onTap: () {
                          // Ensure keyboard shows when tapped
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.perm_media_outlined),
                      onPressed: _pickImage, // Pick and send image
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on_outlined),
                      onPressed: () {
                        _launchMap(); // Launch the map URL
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OpenStreetMapScreen(),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
