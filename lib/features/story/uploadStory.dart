import 'dart:io';
import 'package:convo/features/story/addstoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoryUploader {
  final picker = ImagePicker();

  Future<void> uploadStory(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return AddStoryScreen(imageFile:file);
        }
      ),
    );
  }
}
