import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:woman_safety_app/components/custom_textfield.dart';
import 'package:woman_safety_app/components/secondary_buttons.dart';
import 'package:woman_safety_app/constants/constants.dart' as constants;
import 'package:woman_safety_app/login_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _location = TextEditingController();
  final TextEditingController _view = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool isSaved = true;
  double? rating;
  savereview() async {
    setState(() {
      isSaved = true;
    });
    await FirebaseFirestore.instance
        .collection('reviews')
        .add({
          'location': _location.text,
          'detail': _view.text,
          'rating': rating,
        })
        .then((value) {
          setState(() {
            isSaved = false;
            constants.showFlutterToast('Thanks for thee Review');
          });
        });
  }

  void showalertdialog(BuildContext context, bool isSaved) {
    showDialog(
      context: context,
      builder: (context) {
        if (isSaved) {
          return const Center(child: CircularProgressIndicator());
        }
        return AlertDialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: const [
              Icon(Icons.rate_review, color: constants.themecolor),
              SizedBox(width: 8),
              Text(
                'Add Your Review',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextfield(
                    controller: _location,
                    hinttext: 'Enter Location',
                    ispassword: false,
                    validate: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Location cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    controller: _view,
                    hinttext: 'Write your review...',
                    ispassword: false,
                    validate: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Review cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Rating', style: TextStyle(color: themecolor)),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: constants.themecolor.withOpacity(0.2),
                      highlightColor: constants.themecolor.withOpacity(0.1),
                    ),
                    child: RatingBar(
                      initialRating: rating ?? 1,
                      minRating: 1,
                      allowHalfRating: true,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      ignoreGestures: false,
                      unratedColor: Colors.grey,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star, color: constants.themecolor),
                        half: Icon(
                          Icons.star_half,
                          color: constants.themecolor,
                        ),
                        empty: Icon(
                          Icons.star_border,
                          color: constants.themecolor,
                        ),
                      ),
                      onRatingUpdate: (ratingByUser) {
                        setState(() {
                          rating = ratingByUser;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          actions: [
            SecondaryButton(
              title: 'Save',
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  savereview();
                  _location.clear();
                  _view.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
            SecondaryButton(
              title: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [themecolor, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: const Text(
            'Reviews',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: constants.themecolor,
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: const Text('Add Review', style: TextStyle(color: Colors.white)),
        onPressed: () => showalertdialog(context, false),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Review to SHOW'));
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place, color: themecolor, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ShaderMask(
                              shaderCallback:
                                  (bounds) => LinearGradient(
                                    colors: [
                                      constants.themecolor,
                                      Colors.orange,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                data['location'] ?? ''.toLowerCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (data['detail'] != null &&
                          data['detail'].toString().trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          data['detail'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 206, 127, 7),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RatingBar(
                            initialRating: (data['rating'] ?? 0.0).toDouble(),
                            minRating: 1,
                            ignoreGestures: true,
                            allowHalfRating: true,
                            direction: Axis.horizontal,
                            itemSize: 22,
                            itemCount: 5,
                            unratedColor: Colors.grey[300],
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: constants.themecolor,
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: constants.themecolor,
                              ),
                              empty: Icon(
                                Icons.star_border,
                                color: constants.themecolor,
                              ),
                            ),
                            onRatingUpdate: (_) {},
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (data['rating'] ?? 0.0).toStringAsFixed(1),
                            style: TextStyle(
                              color: constants.themecolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
