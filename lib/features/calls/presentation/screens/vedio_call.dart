import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoVideoCall extends StatefulWidget {
  final String callid;
  final String userid;
  final String otherUserId;

  const ZegoVideoCall({
    super.key,
    required this.callid,
    required this.userid,
    required this.otherUserId,
  });

  @override
  State<ZegoVideoCall> createState() => _ZegoVideoCallState();
}

class _ZegoVideoCallState extends State<ZegoVideoCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 2060914852, // حط App ID الحقيقي بتاعك هنا
      appSign: "ca45d1fc27b54988b912b3dbffeb9c451f15a2100da052d5180023020e8fc340", // App Sign الحقيقي بتاعك
      userID: widget.userid,
      userName: "User: ${widget.userid}",
      callID: widget.callid,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),

    );
  }
}