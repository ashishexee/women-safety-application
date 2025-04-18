import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const themecolor = Color(0xFFfc4572);
const themecolor2 = LinearGradient(
  colors: [Colors.red, Colors.orange],
);
void gotopush(BuildContext context, Widget nextscreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextscreen));
}

void gotopushandremove(BuildContext context, Widget nextscreen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => nextscreen),
    (route) => false,
  );
}

const parentsroute = "/parents-route/";
const childroute = "/child-route/";

/// Shows a custom loading dialog with a progress indicator
/// Returns the dialog's future result
Future<T?> progressindicator<T>(BuildContext context, String message) {
  return showDialog<T>(
    barrierDismissible: false,
    context: context,
    builder:
        (context) => Dialog(
          elevation: 8,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: themecolor),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: const TextStyle(
                    color: themecolor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

void snackbarmessage(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.blue,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    animation: CurvedAnimation(
      parent: AnimationController(
        vsync: Scaffold.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      curve: Curves.easeInOut,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void snackbarerror(BuildContext context, String error) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            error,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    animation: CurvedAnimation(
      parent: AnimationController(
        vsync: Scaffold.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      curve: Curves.easeInOut,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showFlutterToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: themecolor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
