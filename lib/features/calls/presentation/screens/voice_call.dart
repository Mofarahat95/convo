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
      appID: 901987774,
      appSign: "b051b344bdad778fdf5b1aedf650c3b0c41cdb18c288d118be19740b24b73891", // استبدل بـ App Sign الحقيقي
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