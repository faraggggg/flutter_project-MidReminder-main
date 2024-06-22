// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyA7w9llnhNp2dE42gBH6h-mc6yKR5qt1Qo";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      // Add user message to the chat
      _messages.add(Message(
          isUser: true,
          message: message,
          date: DateTime.now(),
          avatarAsset: "assets/person.png")); // Adjust path as needed
    });

    // Send the user message to the bot and wait for the response
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      // Add bot's response to the chat
      _messages.add(Message(
          isUser: false,
          message: response.text ?? "",
          date: DateTime.now(),
          avatarAsset: "assets/m.png")); // Adjust path as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: const Text('Medically'),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Container(
          color: Color.fromARGB(255, 255, 255, 255), // Set the background color here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                      key: ValueKey(
                          index), // Use ValueKey with a unique identifier
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date),
                      avatarAsset: message.avatarAsset,
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: TextFormField(
                        controller: _userMessage,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 24, 23, 23)), // Customize border color when focused
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors
                                    .grey), // Customize border color when enabled
                            borderRadius: BorderRadius.circular(50),
                          ),
                          labelText: "Enter your message",
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)), // Customize label text color
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(15),
                      iconSize: 30,
                      color: Colors.blue,
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  final String avatarAsset;

  const Messages({
    required Key key,
    required this.isUser,
    required this.message,
    required this.date,
    required this.avatarAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? const Color.fromARGB(255, 9, 48, 79)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundImage: AssetImage(avatarAsset),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: isUser ? Colors.white : Colors.black),
                ),
                Text(
                  date,
                  style: TextStyle(color: isUser ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
          if (isUser)
            CircleAvatar(
              backgroundImage: AssetImage(avatarAsset),
            ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  final String avatarAsset;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
    required this.avatarAsset,
  });
}
