import 'package:agora/agora.dart';
import 'package:flutter/services.dart';
import 'package:mbungeweb/utils/logger.dart';

class AgoraClient {
  AgoraClient._internal();
  static final AgoraClient _agoraClient = AgoraClient._internal();
  factory AgoraClient() {
    return _agoraClient;
  }

  // agora id
  static String agoraId = 'c8449ba570c04c52b6a20e01c5e7f6ea';
  Future<void> initAgora() async {
    try {
      await Agora.initAgoraEngine(
        agoraId: agoraId,
        isDebug: true,
      );
    } catch (e) {
      AppLogger.logError('failed to init agora#n${e.toString()}');
    }
  }

  Future<void> joinChannel(String channel) async {
    try {
      await Agora.joinChannel(channel: channel);
    } on PlatformException {
      AppLogger.logError('Failed to join channel');
    }
  }

  Future<void> leaveChannel() async {
    try {
      await Agora.leaveChannel();
    } on PlatformException {
      AppLogger.logError('Failed to leave channel.');
    }
  }
}
