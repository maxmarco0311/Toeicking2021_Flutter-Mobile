import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:toeicking2021/cubits/audio_setting/audio_setting_cubit.dart';
import 'package:toeicking2021/utilities/time_string.dart';
import 'package:toeicking2021/utilities/utilities.dart';

class Player extends StatefulWidget {
  // 需要從Parent Widget傳進的資料
  final String sentenceId;
  // url在PrentWidget時透過AudioSettingState裡的值確定(腔調、性別、語速都在url裡)
  final String url;
  final int repeatedTimes;
  // 更新播放的函式(打開bottom sheet)
  final VoidCallback onSetting;
  final AudioSettingState state;

  const Player({
    Key key,
    @required this.sentenceId,
    @required this.url,
    @required this.onSetting,
    this.repeatedTimes,
    this.state,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AssetsAudioPlayer _assetsAudioPlayer;
  int playedTimes = 0;
  PlayerState _playerState = PlayerState.stop;
  Duration _duration;
  Duration _position;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerFinishSubscription;
  StreamSubscription _playerStateSubscription;
  // getter也可以設定回傳值型別，此處呼叫自訂utilities方法回傳時間字串
  // 取得歌曲時間字串
  String get _durationText => TimeString.formatLessHour(_duration);
  // 取得目前已播放時間字串
  String get _positionText => TimeString.formatLessHour(_position);

  // initState()不可以是同步方法
  @override
  void initState() {
    super.initState();
    // 當中所呼叫的方法也不可以是同步方法
    // 若其中真的需要用同步方法，也要另外包成方法呼叫，不可以直接寫在裡面
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
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      // color記得要跟header一樣
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            // 第一排：播放設定
            Row(
              // MainAxisAlignment.spaceAround左右兩邊不會貼太緊
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // imageUrl: 'assets/images/restaurant4.jpg',
                Image(
                  height: 30.0,
                  width: 30.0,
                  image: AssetImage('assets/images/test.jpg'),
                ),
                // Text('美國腔'),
                Text('男聲'),
                Text('語速(1.0x)'),
                widget.repeatedTimes != null
                    ? Text('重複播放${widget.repeatedTimes - playedTimes}次')
                    : Text('重複播放0次'),
                TextButton(
                  onPressed: widget.onSetting,
                  child: Text('播放設定'),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
            // 第二排：slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _positionText != null ? _positionText : '',
                  // Color(0xFFFFFFFF).withOpacity(0.5)
                  style: TextStyle(color: Colors.black),
                ),
                Expanded(
                  child: Slider.adaptive(
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
                ),
                Text(
                  // 有時候stream觸發的比較慢，會顯示':'字串，要做預防措施才不會顯示出來
                  _durationText != null && _durationText != ':'
                      ? _durationText
                      : '',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            // 第三排：播放按鈕
            // 如果是PlayerState.stop或PlayerState.pause，顯示PLAY按鈕，執行_play函式
            _playerState == PlayerState.stop ||
                    _playerState == PlayerState.pause
                ? IconButton(
                    // 去掉padding
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.play_arrow,
                      size: 40.0,
                    ),
                    onPressed: _play,
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.pause,
                      size: 40.0,
                    ),
                    onPressed: _pause,
                  ),
          ],
        ),
      ),
    );
  }

  // 初始化AssetsAudioPlayer物件
  void _initAssetAudioPlayer() {
    print('init called');
    // 宣告一個空的AssetsAudioPlayer物件
    _assetsAudioPlayer = AssetsAudioPlayer();

    // 監聽"目前播放歌曲"的stream，傳入一個playing物件
    _durationSubscription = _assetsAudioPlayer.current.listen((playingAudio) {
      setState(() {
        // 取得歌曲總長(Duration物件)
        _duration = playingAudio.audio.duration;
      });
    });
    print('_durationText=\'$_durationText\'');
    // 獲得歌曲總長的自訂方法
    _getDuration();
    // 監聽"目前已播放時間"的stream，傳入一個Duration物件
    _positionSubscription =
        _assetsAudioPlayer.currentPosition.listen((position) {
      setState(() {
        _position = position;
      });
    });
    // 監聽"播放狀態"的stream，傳入一個PlayerState物件
    _playerStateSubscription =
        _assetsAudioPlayer.playerState.listen((playState) {
      // 這裡setState()就好了
      setState(() {
        _playerState = playState;
      });
    });
    // 監聽"播放結束時"的stream，傳入一個playing物件
    _playerFinishSubscription =
        _assetsAudioPlayer.playlistAudioFinished.listen((playingAudio) {
      _stop();
      // 重複播放在這裡實作
      if (widget.repeatedTimes != null) {
        if (playedTimes < widget.repeatedTimes) {
          _play();
          playedTimes++;
          print('repeatedTimes:${widget.repeatedTimes}');
          print('playedTimes:$playedTimes');
        }
      }
    });
  }

  // 獲得歌曲時間的方法(先播放觸發stream後立刻stop)
  Future<void> _getDuration() async {
    // 檢查url字串不為空
    if (widget.url != null) {
      // 檢查PlayerState.stop
      if (_playerState == PlayerState.stop) {
        // 開始播放歌曲，才會觸發_assetsAudioPlayer.current這個stream，才能獲得歌曲時間
        await _assetsAudioPlayer.open(
          Audio.network(widget.url),
        );
        // 觸發stream後立刻呼叫_stop()，歌曲才不會真的播放
        _stop();
      }
    }
  }

  // 播放
  Future<void> _play() async {
    // 檢查url字串不為空
    if (widget.url != null) {
      // 如果是PlayerState.stop
      if (_playerState == PlayerState.stop) {
        // 開始播放歌曲
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
      // 如果是PlayerState.pause
      if (_playerState == PlayerState.pause) {
        // 繼續播放
        await _assetsAudioPlayer.play();
      }
    }
  }

  // 暫停
  Future<void> _pause() async {
    // 如果是PlayerState.play
    if (_playerState == PlayerState.play) {
      // 暫停播放
      await _assetsAudioPlayer.pause();
    }
  }

  // 停止(播放)
  Future<void> _stop() async {
    await _assetsAudioPlayer.stop();
    setState(() {
      _position = Duration();
    });
  }
}
