import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woman_safety_app/constants/constants.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final String? date;
  final bool? isMe;
  final String? image;
  final String? messagetype;
  final String? friendName;
  final String? myName;
  final String? timeStamp;

  const SingleMessage({
    super.key,
    this.message,
    this.isMe,
    this.image,
    this.messagetype,
    this.friendName,
    this.myName,
    this.timeStamp,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (messagetype == 'text') {
      return Align(
        alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.7),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            gradient:
                isMe!
                    ? LinearGradient(
                      colors: [themecolor, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: [Colors.orange, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe! ? Radius.circular(12) : Radius.zero,
              bottomRight: isMe! ? Radius.zero : Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message!,
                style: TextStyle(
                  color: isMe! ? Colors.white : Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date ?? '',
                style: TextStyle(
                  color: isMe! ? Colors.white70 : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (messagetype == 'link') {
      return Align(
        alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.7),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            gradient:
                isMe!
                    ? LinearGradient(
                      colors: [themecolor, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: [Colors.orange, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe! ? Radius.circular(12) : Radius.zero,
              bottomRight: isMe! ? Radius.zero : Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await launchUrl(Uri.parse("$message"));
                },
                child: Text(
                  message!,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    decorationColor: isMe! ? Colors.white : Colors.white,
                    color: isMe! ? Colors.white : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date ?? '',
                style: TextStyle(
                  color: isMe! ? Colors.white70 : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (messagetype == 'img') {
      return GestureDetector(
        onTap: () {
          // Open full screen preview
          showDialog(
            context: context,
            builder:
                (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          child: Image.network(message!, fit: BoxFit.contain),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        },
        child: Align(
          alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: size.width * 0.7),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              gradient:
                  isMe!
                      ? LinearGradient(
                        colors: [themecolor, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : LinearGradient(
                        colors: [Colors.orange, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isMe! ? Radius.circular(12) : Radius.zero,
                bottomRight: isMe! ? Radius.zero : Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  'PHOTO',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    decorationColor: isMe! ? Colors.white : Colors.white,
                    color: isMe! ? Colors.white : Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text('nhhn');
    }
  }
}
