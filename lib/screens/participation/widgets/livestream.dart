import 'package:agora/agora_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/cubit/webinar_questions/webinarquestions_cubit.dart';
import 'package:mbungeweb/repository/_repository.dart';
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
  WebinarquestionsCubit webinarquestionsCubit;
  ValueNotifier<bool> isJoined = ValueNotifier(false);

  @override
  void initState() {
    webinarquestionsCubit = WebinarquestionsCubit(
      webinarRepo: WebinarRepo(),
    );
    webinarquestionsCubit.fetchQuestions(_webinarId);
    webinarquestionsCubit.streamChanges(_webinarId);
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
    if (agoraState == AgoraState.joined) {
      _agoraClient.leaveChannel();
    }
    isJoined.dispose();

    agoraState = AgoraState.not_joined;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          SizedBox(
            width: size.width * 0.6,
            height: size.height,
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
          SizedBox(
            width: size.width * 0.4,
            height: size.height,
            child: Container(
              color: Colors.white,
              child: BlocProvider(
                create: (context) {
                  return webinarquestionsCubit;
                },
                child:
                    BlocConsumer<WebinarquestionsCubit, WebinarquestionsState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is WebinarquestionsInitial) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      );
                    }
                    if (state is WebinarquestionsError) {
                      return Center(child: Text("An error occured"));
                    }
                    if (state is WebinarquestionsSuccess) {
                      final questions = state.questions;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              right: 15.0,
                              left: 15.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Questions",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.replay_outlined),
                                  onPressed: () {
                                    BlocProvider.of<WebinarquestionsCubit>(
                                            context)
                                        .fetchQuestions(
                                      _webinarId,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          questions != null || questions.isNotEmpty
                              ? SizedBox(
                                  height: size.height * 0.85,
                                  width: size.width * 0.28,
                                  child: ListView.builder(
                                    itemCount: questions.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Icon(Icons.person),
                                        ),
                                        title: Text(
                                            "${questions[index].user.firstName} ${questions[index].user.lastName}"),
                                        subtitle: Text(questions[index].body),
                                      );
                                    },
                                  ),
                                )
                              : Center(child: Text("No questions")),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
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
