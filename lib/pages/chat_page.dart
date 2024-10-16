import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // textController
  final TextEditingController _messageController = TextEditingController();

  // chat and auth services
  final ChatServices _chatServices = ChatServices();

  final AuthService _authService = AuthService();

  // for textfield focus

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to the focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        // then the amount of time remaining space will be calculated
        // then scroll to the bottom

        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // wait a bit for the widget to build , then scroll down
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    // if the message is not empty
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        title: Text(widget.receiverEmail.toUpperCase()),
      ),
      body: Column(
        children: [
          // display messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserinput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatServices.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return const Text("Error");
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading ......");
          }

          // return List view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map<Widget>((message) => _buildMessageItem(message))
                .toList(),
          );
        });
  }

// build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> message = doc.data() as Map<String, dynamic>;

    // is the message from the current user
    bool isMe = message["senderID"] == _authService.getCurrentUser()!.uid;

    // align the message to the right if it is from the current user
    var alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: ChatBubble(message: message["message"], isCurrentUser: isMe),
    );
  }

  // build message input
  Widget _buildUserinput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Type a message",
              textController: _messageController,
              obsecureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
