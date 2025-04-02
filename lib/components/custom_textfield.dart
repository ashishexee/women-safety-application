import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String? hinttext;
  final TextEditingController? controller;
  const CustomTextfield({
    super.key,
    this.hinttext,
    this.controller,
    this.validate,
    this.onsave,
    this.maxline,
    this.ispassword,
    this.enable,
    this.keyboardtypee,
    this.textInputAction,
    this.focusnode,
    this.suffix,
    this.preffix,
  });
  final String? Function(String?)? validate;
  final Function(String?)? onsave;
  final int? maxline;
  final bool? ispassword;
  final bool? enable;
  final TextInputType? keyboardtypee;
  final TextInputAction? textInputAction;
  final FocusNode? focusnode;
  final Widget? suffix;
  final Widget? preffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable == true ? true : enable,
      maxLines: maxline == null ? 1 : 0,
      onSaved: onsave,
      focusNode: focusnode,
      textInputAction: textInputAction,
      keyboardType: keyboardtypee ?? TextInputType.name,
      controller: controller,
      validator: validate,
      obscureText: ispassword == false ? false : true,

      decoration: InputDecoration(
        prefixIcon: preffix,
        suffixIcon: suffix,
        labelText: hinttext ?? "Hint Text ...",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(style: BorderStyle.solid, color: themecolor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(style: BorderStyle.solid, color: themecolor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(style: BorderStyle.solid, color: themecolor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(style: BorderStyle.solid, color: themecolor),
        ),
      ),
    );
  }
}

const themecolor = Color(0xFFfc4572);
