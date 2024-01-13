import 'package:flutter/material.dart';

class AppWidgets {

  static Widget buildCircularProfilePicture(String imageUrl, double size) {
    return CircleAvatar(
      radius: size / 2, // Adjust the radius as needed
      backgroundColor: Colors.transparent, // Optional: Make the background transparent
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }

}