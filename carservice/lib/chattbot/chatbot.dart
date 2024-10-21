import 'dart:developer';

import 'package:carservice/chattbot/chatapi.dart';
import 'package:carservice/chattbot/message.dart';
import 'package:carservice/packages/packages.dart';
import 'package:carservice/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String img;
  const ChatPage({super.key, required this.img});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _userMessage = TextEditingController();
  final List<Message> _message = [];

  Future<void> tolkWithChatBot() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: API_KEY);

    String _usermsg = _userMessage.text;

    setState(() {
      _message.add(
          Message(isUser: true, message: _usermsg, dateTime: DateTime.now()));
    });

    final content = Content.text(_usermsg);

    final response = await model.generateContent([content]);

    _message.add(Message(
        isUser: false, message: response.text ?? "", dateTime: DateTime.now()));
    log("Reponse by chatbot : ${response.text}");
    _userMessage.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return const HomeScreen();
                  },
                ));
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          centerTitle: true,
          shape: const BeveledRectangleBorder(side: BorderSide(width: 0.2)),
          title: const Text(
            'ChatBot',
            style: TextStyle(
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _message.length,
                itemBuilder: (context, index) {
                  final message = _message[index];
                  return Messages(
                      image: widget.img,
                      isUser: message.isUser,
                      message: message.message,
                      dateTime: DateFormat('HH:mm').format(message.dateTime));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        height: 50,
                        child: TextFormField(
                          controller: _userMessage,
                          decoration: InputDecoration(
                            hintText: "Ask ChatBot",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: IconButton(
                              onPressed: () {
                                tolkWithChatBot();
                              },
                              icon: const Icon(Icons.send)))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
