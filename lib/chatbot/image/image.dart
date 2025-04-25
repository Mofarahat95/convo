import 'package:convo/chatbot/gen/l10n.dart';
import 'package:convo/chatbot/image/config.dart';
import 'package:convo/chatbot/image/generate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImagePage extends ConsumerWidget {
  const ImagePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).image_generation),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).generate),
              Tab(text: S.of(context).config),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const GenerateTab(),
            const ConfigTab(),
          ],
        ),
      ),
    );
  }
}
