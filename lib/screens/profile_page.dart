import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_profileImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final profilePicRef = storageRef.child('profile_pictures/${FirebaseAuth.instance.currentUser?.uid}.jpg');

      try {
        await profilePicRef.putFile(_profileImage!);
        final downloadUrl = await profilePicRef.getDownloadURL();
        print('Uploaded image URL: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Profile Picture'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
