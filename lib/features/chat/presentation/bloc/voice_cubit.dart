// import 'package:bloc/bloc.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// class VoiceCubit extends Cubit<VoiceState> {
//   final Record _record = Record();
//   String? _filePath;
//
//   VoiceCubit() : super(VoiceInitial());
//   //
//   Future<void> startRecording() async {
//     _filePath = await _getTempFilePath();
//     await _record.start(path: _filePath);
//     emit(VoiceRecording());
//   }
//
//   Future<String?> stopRecording() async {
//     await _record.stop();
//     emit(VoiceRecorded(_filePath!));
//     return _filePath;
//   }
//
//   Future<String> _getTempFilePath() async {
//     final dir = await getTemporaryDirectory();
//     return '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';
//   }
// }
//
// abstract class VoiceState {}
// class VoiceInitial extends VoiceState {}
// class VoiceRecording extends VoiceState {}
// class VoiceRecorded extends VoiceState {
//   final String filePath;
//   VoiceRecorded(this.filePath);
// }
