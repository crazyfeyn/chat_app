import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_servrices.dart';
import 'package:flutter_application_1/views/widgets/send_image.dart';

class UserSeperateScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String chrId;
  final FirebaseServices firebaseServices;
  final String receiverEmail;
  final String senderEmail;

  UserSeperateScreen({
    Key? key,
    required this.senderId,
    required this.receiverId,
    required this.chrId,
    required this.firebaseServices,
    required this.receiverEmail,
    required this.senderEmail,
  }) : super(key: key);

  @override
  State<UserSeperateScreen> createState() => _UserSeperateScreenState();
}

class _UserSeperateScreenState extends State<UserSeperateScreen> {
  final _formKey = GlobalKey<FormState>();
  final messageEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isDonwloaded = true;

  void donwloadedImage() {
    setState(() {
      isDonwloaded = false;
    });
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> startChat(String message) async {
    await widget.firebaseServices.startChat(
      widget.receiverId,
      widget.senderId,
      widget.chrId,
      message,
    );
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    donwloadedImage();
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F2A),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          widget.receiverEmail,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: widget.firebaseServices.getActiveChats(
          widget.receiverEmail,
          widget.senderEmail,
        ),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String info = snapshot.data!.docs[index]['message'];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: widget.senderId ==
                                snapshot.data!.docs[index]['sender_id']
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          isDonwloaded
                              ? const CircularProgressIndicator()
                              : info.contains(
                                      'https://firebasestorage.googleapis.com')
                                  ? Container(
                                      height: 200,
                                      width: 200,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Image.network(
                                        info,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(info),
                                    ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => SendImage(
                                    chrId: widget.chrId,
                                    receiverId: widget.receiverId,
                                    senderId: widget.senderId,
                                  ));
                        },
                        icon:
                            const Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: messageEditingController,
                          decoration: const InputDecoration(
                              focusColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: 'Enter your message',
                              hintStyle: TextStyle(color: Colors.white)),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a message';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            startChat(messageEditingController.text);
                            messageEditingController.clear();
                          }
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
