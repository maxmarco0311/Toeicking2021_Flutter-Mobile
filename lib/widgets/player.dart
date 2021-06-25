import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  // 需要從Parent Widget傳進的資料
  final String sentenceId;
  // url在PrentWidget時透過AudioSettingState裡的值確定(腔調、性別、語速都在url裡)
  final String url;
  final int repeatedTimes;
  // 更新播放的函式
  final VoidCallback onSetting;

  const Player({
    Key key,
    @required this.sentenceId,
    @required this.url,
    @required this.onSetting,
    this.repeatedTimes,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String url;
  AssetsAudioPlayer _assetsAudioPlayer;
  PlayerState _playerState = PlayerState.stop;
  Duration _duration;
  Duration _position;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerFinishSubscription;
  StreamSubscription _playerStateSubscription;

  get _durationText {
    String finalText;
    String minutePart =
        _duration?.toString()?.split('.')?.first?.split(':')?.elementAt(1) ??
            '';
    String secondPart =
        _duration?.toString()?.split('.')?.first?.split(':')?.elementAt(2) ??
            '';
    finalText = '$minutePart:$secondPart';
    return finalText ?? '';
  }

  get _positionText {
    String finalText;
    String minutePart =
        _position?.toString()?.split('.')?.first?.split(':')?.elementAt(1) ??
            '';
    String secondPart =
        _position?.toString()?.split('.')?.first?.split(':')?.elementAt(2) ??
            '';
    finalText = '$minutePart:$secondPart';
    return finalText ?? '';
  }

  @override
  Future<void> initState() async {
    super.initState();
    await _initAssetAudioPlayer();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerFinishSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.grey.shade200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('美國腔'),
                    Text('男聲'),
                    Text('正常(1.0x)'),
                  ],
                ),
              ),
              TextButton(
                onPressed: widget.onSetting,
                child: Text('播放設定'),
                style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Column(
                children: [
                  Slider.adaptive(
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey[350],
                    value: (_position != null &&
                            _duration != null &&
                            _position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                    onChanged: (newValue) {
                      final position = newValue * _duration.inMilliseconds;
                      _assetsAudioPlayer.seek(
                        Duration(
                          milliseconds: position.round(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _positionText != null
                            ? _positionText
                            : SizedBox.shrink(),
                        style: TextStyle(
                            color: Color(0xFFFFFFFF).withOpacity(0.5)),
                      ),
                      Text(
                        _durationText != null
                            ? _durationText
                            : SizedBox.shrink(),
                        style: TextStyle(
                            color: Color(0xFFFFFFFF).withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  _playerState == PlayerState.stop ||
                          _playerState == PlayerState.pause
                      ? IconButton(
                          icon: Icon(Icons.play_circle_filled_outlined),
                          onPressed: _play,
                        )
                      : IconButton(
                          icon: Icon(Icons.pause_circle_filled_outlined),
                          onPressed: _pause,
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _initAssetAudioPlayer() async {
    _assetsAudioPlayer = AssetsAudioPlayer();

    _durationSubscription = _assetsAudioPlayer.current.listen((playingAudio) {
      setState(() {
        _duration = playingAudio.audio.duration;
      });
    });
    _positionSubscription =
        _assetsAudioPlayer.currentPosition.listen((position) {
      setState(() {
        _position = position;
      });
    });
    _playerStateSubscription =
        _assetsAudioPlayer.playerState.listen((playState) {
      setState(() {
        _playerState = playState;
      });
    });
    _playerFinishSubscription =
        _assetsAudioPlayer.playlistAudioFinished.listen((playingAudio) async {
      await _assetsAudioPlayer.stop();
      setState(() {
        _position = _duration;
        _playerState = PlayerState.stop;
      });
      // 重複播放在這裡實作
    });
  }

  Future<void> _play() async {
    if (_playerState == PlayerState.stop) {
      await _assetsAudioPlayer.open(
        Audio.network(
          widget.url,
          metas: Metas(
            id: widget.sentenceId,
            title: '多益必考金句${widget.sentenceId}',
            artist: 'Max Ching',
            album: '多益金聽力訓練',
            image: MetasImage.asset('path'),
          ),
        ),
        showNotification: true,
      );
    }
    if (_playerState == PlayerState.pause) {
      await _assetsAudioPlayer.play();
    }
    setState(() {
      _playerState = PlayerState.play;
    });
  }

  Future<void> _pause() async {
    if (_playerState == PlayerState.play) {
      await _assetsAudioPlayer.pause();
      setState(() {
        _playerState = PlayerState.pause;
      });
    }
  }

  // Future<void> _stop() async {
  //   if (_playerState == PlayerState.play || _playerState == PlayerState.pause) {
  //     await _assetsAudioPlayer.stop();
  //     setState(() {
  //       _playerState = PlayerState.stop;
  //       _position = Duration();
  //     });
  //   }
  // }

}
