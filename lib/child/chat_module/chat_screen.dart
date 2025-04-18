import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woman_safety_app/child/chat_module/message_text_field.dart';
import 'package:woman_safety_app/child/chat_module/single_message.dart';
import 'package:woman_safety_app/constants/constants.dart';

class ChatScreen extends StatefulWidget {
  final String currentuserid;
  final String friendid;
  final String friendname;
  const ChatScreen({
    super.key,
    required this.currentuserid,
    required this.friendid,
    required this.friendname,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? type;
  String? myname;
  final ScrollController _scrollController = ScrollController();
  getstatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentuserid)
        .get()
        .then((value) {
          setState(() {
            type = value.data()!['type'];
            myname = value.data()!['name'];
          });
        });
  }

  @override
  void initState() {
    getstatus();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.friendname.toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: themecolor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentuserid)
                      .collection('messages')
                      .doc(widget.friendid)
                      .collection('chats')
                      .orderBy('date', descending: false)
                      .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Messages to show'));
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(); // Scroll to bottom after messages are loaded
                });
                return ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var data =
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>?;
                    final data1 = snapshot.data!.docs[index];
                    if (data == null) {
                      return const SizedBox(); // Skip rendering if data is null
                    }

                    bool isme = data['senderid'] == widget.currentuserid;

                    // Safely handle the date field
                    DateTime dateTime =
                        (data['date'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        // Delete message from your side
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.currentuserid)
                            .collection('messages')
                            .doc(widget.friendid)
                            .collection('chats')
                            .doc(data1.id)
                            .delete();
                        // Now find and delete message from friend's side
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.friendid)
                            .collection('messages')
                            .doc(widget.currentuserid)
                            .collection('chats')
                            .doc(data1.id)
                            .delete();
                        showFlutterToast('Message deleted successfully');
                      },
                      background: Container(
                        color:
                            themecolor, // Background color for the delete action
                        alignment:
                            Alignment.centerRight, // Align content to the right
                        padding: const EdgeInsets.only(
                          right: 20,
                        ), // Add padding for spacing
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ), // Delete icon
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      direction:
                          DismissDirection
                              .endToStart, // Allow swipe from right to left
                      child: SingleMessage(
                        message: data['message'] ?? '',
                        date: dateTime.toString(),
                        isMe: isme,
                        friendName: widget.friendname,
                        myName: myname ?? 'Unknown',
                        messagetype: data['messagetype'] ?? 'text',
                      ),
                    );
                  },
                );
              },
            ),
          ),
          MessageTextField(
            currentid: widget.currentuserid,
            friendid: widget.friendid,
          ),
        ],
      ),
    );
  }
}
