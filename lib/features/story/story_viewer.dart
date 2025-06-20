import 'package:convo/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';


class StoryViewerScreen extends StatelessWidget {
  final Map<String, dynamic> story;

  StoryViewerScreen({super.key, required this.story});

  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          story['mediaType'] == 'image'
              ? StoryItem.pageImage(
            url: story['mediaUrl'],
            controller: controller,
            caption: Text(story['caption'] ?? '',style: quicksand14(),textAlign: TextAlign.center,),
          )
              : StoryItem.pageVideo(
            story['mediaUrl'],
            controller: controller,
            caption: Text(story['caption'] ?? ''),
          ),
        ],
        controller: controller,
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
