import 'package:agora/agora_view.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/utils/agora.dart';

enum AgoraState {
  not_joined,
  connecting,
  joined,
}

class LivestreamPage extends StatefulWidget {
  final String webinarId;
  final String agenda;
  const LivestreamPage({Key key, @required this.webinarId, this.agenda})
      : super(key: key);
  @override
  _LivestreamPageState createState() => _LivestreamPageState();
}

class _LivestreamPageState extends State<LivestreamPage> {
  AgoraState agoraState;
  AgoraClient _agoraClient = AgoraClient();
  String get _webinarId => widget.webinarId;
  String get _agenda => widget.agenda;
  ValueNotifier<bool> isJoined = ValueNotifier(false);

  @override
  void initState() {
    _agoraClient.initAgora();
    super.initState();
    isJoined.addListener(() {
      setState(() {});
    });
    agoraState = AgoraState.not_joined;
  }

  timer() {
    Future.delayed(
      Duration(seconds: 6),
      () {
        setState(() {
          agoraState = AgoraState.joined;
        });
        isJoined.value = true;
      },
    );
  }

  @override
  void dispose() {
    isJoined.dispose();
    agoraState = AgoraState.not_joined;
    _agoraClient.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          _agenda ?? "",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AgoraView(),
                  ),
                  agoraState == AgoraState.connecting
                      ? Center(
                          child: Text(
                            agoraState.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox.shrink(),
                  isJoined.value ? _buildReady() : buildIntial(),
                ],
              ),
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
          _agoraClient.joinChannel(_webinarId ?? "");
          setState(() {
            agoraState = AgoraState.connecting;
          });
          timer();
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
              isJoined.value = false;
              setState(() {
                agoraState = AgoraState.not_joined;
              });
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
