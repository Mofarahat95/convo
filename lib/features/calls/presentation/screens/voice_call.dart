import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZimVoiceCall extends StatelessWidget {
  final String callid;
  final String userid;
  final String otherUserId;

  const ZimVoiceCall({
    super.key,
    required this.callid,
    required this.userid,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 2060914852,
      appSign: "ca45d1fc27b54988b912b3dbffeb9c451f15a2100da052d5180023020e8fc340", // استبدل بـ App Sign الحقيقي
      userID: userid,
      userName: "User: $userid",
      callID: callid,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..audioVideoViewConfig = ZegoCallAudioVideoViewConfig(
          showAvatarInAudioMode: true,
          showSoundWavesInAudioMode: false,
        ),
    );
  }
}