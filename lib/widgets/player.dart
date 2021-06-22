import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  // 需要從Parent Widget傳進的資料
  final String sentenceId;
  // url在PrentWidget時透過AudioSettingState裡的值確定(腔調、性別、語速都在url裡)
  final String url;
  final int repeatedTimes;

  const Player({
    Key key,
    @required this.sentenceId,
    @required this.url,
    @required this.repeatedTimes,
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
  void initState() {
    super.initState();
    _initAssetAudioPlayer();
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
    return Container();
  }

  void _initAssetAudioPlayer() {
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
        _assetsAudioPlayer.playlistAudioFinished.listen((playingAudio) {
      setState(() {
        _position = _duration;
        _playerState = PlayerState.stop;
      });
      // 重複播放在這裡實作
    });
  }

  Future<void> _play() async {
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
    await _assetsAudioPlayer.play();
    setState(() {
      _playerState = PlayerState.play;
    });
  }

  Future<void> _pause() async {
    await _assetsAudioPlayer.pause();
    setState(() {
      _playerState = PlayerState.pause;
    });
  }

  Future<void> _stop() async {
    await _assetsAudioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stop;
      _position = Duration();
    });
  }
}
