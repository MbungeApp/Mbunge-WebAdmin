import 'package:agora/agora_view.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/utils/agora.dart';

class LivestreamPage extends StatefulWidget {
  @override
  _LivestreamPageState createState() => _LivestreamPageState();
}

class _LivestreamPageState extends State<LivestreamPage> {
  AgoraClient _agoraClient = AgoraClient();
  ValueNotifier<bool> isJoined = ValueNotifier(false);

  @override
  void initState() {
    _agoraClient.initAgora();
    super.initState();
    isJoined.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isJoined.dispose();
    _agoraClient.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 6,
            child: Stack(
              children: [
                AgoraView(),
                isJoined.value ? _buildReady() : buildIntial(),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.red,
              child: Center(),
            ),
          )
        ],
      ),
    );
  }

  buildIntial() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _buildBtn(
        title: "start",
        icon: Icons.call,
        onTap: () {
          _agoraClient.joinChannel("test");
        },
        bgColor: Colors.green,
      ),
    );
  }

  _buildReady() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBtn(
            title: "mute_audio",
            icon: Icons.volume_off,
            mini: true,
            onTap: () {},
            bgColor: Colors.teal,
          ),
          SizedBox(width: 20),
          _buildBtn(
            title: "end",
            icon: Icons.call_end,
            onTap: () {
              _agoraClient.leaveChannel();
            },
            bgColor: Colors.red,
          ),
          SizedBox(width: 20),
          _buildBtn(
            title: "mute_video",
            icon: Icons.videocam_off,
            mini: true,
            onTap: () {},
            bgColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  _buildBtn({
    @required String title,
    @required IconData icon,
    @required Function onTap,
    @required Color bgColor,
    bool mini = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: FloatingActionButton(
        mini: mini,
        backgroundColor: bgColor,
        heroTag: title,
        child: Icon(icon),
        onPressed: onTap,
      ),
    );
  }
}
