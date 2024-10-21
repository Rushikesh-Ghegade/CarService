import 'package:flutter/material.dart';

class Message {
  bool isUser;
  String message;
  DateTime dateTime;

  Message(
      {required this.isUser, required this.message, required this.dateTime});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String dateTime;
  final String image;
  const Messages(
      {super.key,
      required this.image,
      required this.isUser,
      required this.message,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (isUser)
              ? Row(
                  children: [
                    const Spacer(),
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(image),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      padding: const EdgeInsets.all(10),
                      // margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
                      // left: MediaQuery.of(context).size.width / 4,
                      // right: 10,
                      // ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(234, 255, 1, 86),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            dateTime,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 14, 189),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            dateTime,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("lib/images/chatbot.jpg"),
                              ),
                            )),

                        // Spacer(),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
