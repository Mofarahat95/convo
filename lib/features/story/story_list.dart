import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/core/utils/styles_manager.dart';
import 'package:convo/features/ADS/Ads_Manger.dart';
import 'package:flutter/material.dart';
import 'story_viewer.dart';

Stream<List<Map<String, dynamic>>> getStories() {
  final now = DateTime.now();

  return FirebaseFirestore.instance
      .collection('Stories')
      .where('expireDate', isGreaterThan: now)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}

Widget buildStoriesBar(BuildContext context) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: getStories(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final stories = snapshot.data ?? [];

      return SizedBox(
        height: 200,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return GestureDetector(
              onTap: () {

                AdManager.showInterstitialAdBeforeAction(
                  onContinue: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(story: story),
                      ),
                    );
                  },
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 6,right: 8,left: 8),
                    child: CircleAvatar(
                      radius: 37,
                      backgroundImage: NetworkImage(story['mediaUrl']),
                    ),
                  ),
                  Text(
                    story['userName'],
                    style: quicksand14(),
                  ),
                  SizedBox(height: 2,)
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
