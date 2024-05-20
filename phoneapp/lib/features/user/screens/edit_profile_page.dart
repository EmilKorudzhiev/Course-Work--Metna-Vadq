import 'dart:io';

import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String? userImageUrl;
  final bool isDefaultImage;

  const EditProfilePage({super.key, required this.userImageUrl, required this.isDefaultImage});
  @override
  _EditProfilePageState createState() => _EditProfilePageState(userImageUrl: userImageUrl, isDefaultImage: isDefaultImage);
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final String? userImageUrl;
  final bool isDefaultImage;

  _EditProfilePageState({required this.userImageUrl, required this.isDefaultImage});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактиране на профил'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(builder:
              (context) {
                if (_imageFile == null) {
                  if (isDefaultImage) {
                    return const CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage(
                          "lib/assets/pictures/userProfileDefault.jpg"),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(userImageUrl!),
                    );
                  }
                } else {
                  return CircleAvatar(
                    radius: 100,
                    backgroundImage: FileImage(File(_imageFile!.path)),
                  );
                }
              }
            ),
            ElevatedButton(
              child: const Text('Избери снимка', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
                if (imageFile != null) {
                  setState(() {
                    _imageFile = imageFile;
                  });
                }
              },
            ),
            ElevatedButton(
              child: const Text('Запази промени', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                bool isUpdated = await ref.read(userControllerProvider).updateProfilePicture(_imageFile!.path);
                if (isUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Профилната снимка е обновена успешно!'),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Възникна грешка при обновяването на профилната снимка!'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}