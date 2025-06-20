import 'dart:io';
import 'package:convo/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:convo/features/home/presentation/bloc/home_cubit.dart';

class AddStoryScreen extends StatefulWidget {
  final File imageFile;

  const AddStoryScreen({super.key, required this.imageFile});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController captionController = TextEditingController();
  bool isUploading = false;

  Future<void> uploadStory() async {
    setState(() {
      isUploading = true;
    });

    final user = HomeCubit.get(context).currentUser;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}';
    final ref = FirebaseStorage.instance
        .ref()
        .child('stories')
        .child(user!.id)
        .child(fileName);

    final uploadTask = await ref.putFile(widget.imageFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    final now = DateTime.now();
    final expire = now.add(const Duration(hours: 24));

    await FirebaseFirestore.instance.collection('Stories').doc(user.id).set({
      'mediaUrl': downloadUrl,
      'mediaType': 'image',
      'caption': captionController.text.trim(),
      'userId': user.id,
      'userName': user.name,
      'picUrl': user.profilePic,
      'time': now,
      'expireDate': expire,
    });

    setState(() {
      isUploading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary950,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    widget.imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isUploading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: captionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Caption',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  onPressed: isUploading ? null : uploadStory,
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
