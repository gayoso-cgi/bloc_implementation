import 'package:bloc_implementation/src/helper/config/theme_color.dart';
import 'package:bloc_implementation/src/helper/config/theme_font.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class PlayerVideoComponent extends StatefulWidget {
  KategoryContentVideo? video;

  PlayerVideoComponent(this.video);

  @override
  _PlayerVideoComponentState createState() => _PlayerVideoComponentState();
}

class _PlayerVideoComponentState extends State<PlayerVideoComponent> {
  late YoutubePlayerController _controller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  bool fullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video!.youtubeVideoid!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    if (mounted) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.reset();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 1.725,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 9),
      padding: EdgeInsets.symmetric(vertical: 14),
      child: ClipRRect(
        borderRadius: _controller.value.isFullScreen
            ? BorderRadius.all(Radius.circular(0))
            : BorderRadius.all(Radius.circular(8)),
        child: Stack(
          children: [
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: primaryColor,
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                ],
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {},
              ),
              builder: (context, player) => Scaffold(
                body: Container(),
              ),
            ),
            _controller.value.isPlaying
                ? Container()
                : Positioned(
                    right: 10,
                    bottom: 8,
                    child: Container(
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color(0xffF8B52B),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                                "${Duration(
                                  hours: int.tryParse(widget
                                      .video!.meta!.length!
                                      .split(":")[0])!,
                                  minutes: int.tryParse(widget
                                      .video!.meta!.length!
                                      .split(":")[1])!,
                                  seconds: int.tryParse(widget
                                      .video!.meta!.length!
                                      .split(":")[2])!,
                                ).inMinutes.toString()}.${widget.video!.meta!.length!.split(":")[2]}",
                                style: textStyle10PxW400))),
                  )
          ],
        ),
      ),
    );
  }
}
