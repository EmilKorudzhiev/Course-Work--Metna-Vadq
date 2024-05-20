import 'package:flutter/material.dart';

class AuthWidgets {

  static Widget buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  static Widget buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    var _obscureText = isPassword;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextField(
          controller: controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        );
      },
    );
  }

}