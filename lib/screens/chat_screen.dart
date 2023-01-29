// ignore_for_file: avoid_print, must_be_immutable

import 'package:chat/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
late User signInUser;

class ChatScreen extends StatefulWidget {
  static const screenRoutes = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String? messageText;
  final messageController = TextEditingController();

  void messagesStream() async {
    await for (var snap in _fireStore.collection('message').snapshots()) {
      for (var message in snap.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, SignIn.screenRoutes);
            },
            child: const Icon(
              Icons.logout,
              shadows: [
                Shadow(blurRadius: 21, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ],
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow.shade900,
                Colors.yellow.shade100,
                Colors.yellow.shade900,
              ],
            ),
          ),
          height: double.infinity,
          alignment: Alignment.bottomLeft,
        ),
      ),
      body: chat_Screen(context),
    );
  }

  // ignore: non_constant_identifier_names
  chat_Screen(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MessageStreamBuilder(),
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.yellow.shade900,
                    width: 2,
                  ),
                ),
                color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onChanged: (value) => messageText = value,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: 'Write Your Message Here...',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Icon(Icons.photo_camera,
                    color: Colors.yellow.shade900,
                    shadows: const [Shadow(blurRadius: 11, color: Colors.yellow)]),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {

                    messageController.clear();
                    _fireStore
                        .collection('message')
                        .add({'text': messageText, 'sender': signInUser.email,'time' :FieldValue.serverTimestamp()});
                    messagesStream();
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                        fontFamily: 'AbrilFatface',
                        shadows: const [
                          Shadow(blurRadius: 11, color: Colors.yellow),
                        ],
                        color: Colors.yellow.shade900,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  MessageBox({this.text, this.sender, required this.isMe, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: const TextStyle(color: Colors.grey),
          ),
          Material(
            borderRadius: isMe ? const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) : const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 10,
            color:  isMe ? Colors.blue.shade900 : Colors.grey.shade700,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style:  const TextStyle(fontSize: 20,  color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('message').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageBox> messageWidgets = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.yellow.shade900,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signInUser.email;

            if (currentUser == messageSender) {
              //
            }
            final messageWidget = MessageBox(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender);
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: messageWidgets,
            ),
          );
        });
  }
}
