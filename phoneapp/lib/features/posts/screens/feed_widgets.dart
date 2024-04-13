import 'package:flutter/material.dart';

class AppWidgets {

  static Widget buildCircularProfilePicture(String imageUrl, double circleSize) {
    if (imageUrl.isEmpty || imageUrl == "null") {
      return CircleAvatar(
        radius: circleSize / 2, // Adjust the radius as needed
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: circleSize - 10,
        ),
      );
    }
    return CircleAvatar(
      radius: circleSize / 2, // Adjust the radius as needed
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: circleSize,
          height: circleSize,
        ),
      ),
    );
  }

}