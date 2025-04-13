import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final currentuser = FirebaseAuth.instance.currentUser;

        if (currentuser == null) {
          return Scaffold(
            appBar: AppBar(title: Text("Select Guardian")),
            body: Center(child: Text("User is not signed in.")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text("Select Guardian")),
          body: StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('users')
                    .where('type', isEqualTo: 'parent')
                    .where('childEmail', isEqualTo: currentuser.email)
                    .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final d = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(title: Text(d['name'])),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
