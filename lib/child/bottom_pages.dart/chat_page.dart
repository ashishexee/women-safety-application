import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Guardian")),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .where('type', isEqualTo: 'parent')
                .where(
                  'childEmail',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email,
                )
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator.adaptive();
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
  }
}
