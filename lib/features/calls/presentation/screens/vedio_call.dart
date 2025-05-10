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
      appID: 901987774, // حط App ID الحقيقي بتاعك هنا
      appSign: "b051b344bdad778fdf5b1aedf650c3b0c41cdb18c288d118be19740b24b73891", // App Sign الحقيقي بتاعك
      userID: widget.userid,
      userName: "User: ${widget.userid}",
      callID: widget.callid,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      // eventHandler: ZegoUIKitPrebuiltCallEventHandler(
      //   onOnlySelfInRoom: () {
      //     // الحدث ده هيشتغل لما المستخدم الآخر مش موجود
      //     print("Waiting for ${widget.otherUserId} to join...");
      //   },
      //  ),
    );
  }
}