import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:toeicking2021/cubits/audio_setting/audio_setting_cubit.dart';
import 'package:toeicking2021/utilities/time_string.dart';
import 'package:toeicking2021/utilities/utilities.dart';
import 'package:toeicking2021/utilities/value_handler.dart';

class Player extends StatefulWidget {
  // 需要從Parent Widget傳進的資料
  final String sentenceId;
  // url在Prent Widget時透過AudioSettingState裡的值確定(腔調、性別、語速都在url裡)
  final String url;
  // 更新播放的函式(打開bottom sheet)
  final VoidCallback onSetting;
  // 傳入state
  final AudioSettingState state;
  // 傳入cubit
  final AudioSettingCubit cubit;

  const Player({
    Key key,
    @required this.sentenceId,
    @required this.url,
    @required this.onSetting,
    @required this.state,
    @required this.cubit,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // 所有該頁狀態變數
  // 1. 播放用的player
  AssetsAudioPlayer _assetsAudioPlayer;
  // 2. 取得duration用的player
  AssetsAudioPlayer _anotherAudioPlayer;
  // 3. 已播放次數，主要用在重複播放時
  int _playedTimes = 0;
  // 4. 播放狀態變數，這個最重要
  PlayerState _playerState = PlayerState.stop;
  // 5. 歌曲長度
  Duration _duration;
  // 6. 已播放時間
  Duration _position;
  // 7. 監聽歌曲長度stream的訂閱物件
  StreamSubscription _durationSubscription;
  // 8. 監聽已播放時間stream的訂閱物件
  StreamSubscription _positionSubscription;
  // 9. 監聽歌曲播完時stream的訂閱物件
  StreamSubscription _playerFinishSubscription;
  // 10. 監聽播放狀態stream的訂閱物件
  StreamSubscription _playerStateSubscription;
  // 11. 監聽自訂播放設定update時stream的訂閱物件
  StreamSubscription _audioSettingStatusSubscription;
  // 12. 控制重複播放第一次必須是按play鍵的變數
  bool _holdPlay = false;
  // getter也可以設定回傳值型別，此處呼叫自訂utilities方法回傳時間字串
  // 取得歌曲時間字串
  String get _durationText => TimeString.formatLessHour(_duration);
  // 取得目前已播放時間字串
  String get _positionText => TimeString.formatLessHour(_position);

  // initState()不可以是同步方法
  @override
  void initState() {
    super.initState();
    // initState()當中所呼叫的方法也"不可以"是同步方法
    // 若其中真的需要用同步方法，也要另外包成方法呼叫，不可以直接寫在裡面
    _initAssetAudioPlayer();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    _anotherAudioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerFinishSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioSettingStatusSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      // color記得要跟ExpandableBottomSheet的header一樣
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
                Image(
                  height: 30.0,
                  width: 30.0,
                  image: AssetImage(
                    ValueHandler.toAccentImageUrl(widget.state.accent),
                  ),
                ),
                // Text('美國腔'),
                Text(
                  ValueHandler.toGenderString(widget.state.gender),
                ),
                Text(
                  ValueHandler.toRateString(widget.state.rate),
                ),
                widget.state.repeatedTimes != null
                    ? Text('重複播放${widget.state.repeatedTimes - _playedTimes}次')
                    : Text('重複播放0次'),
                TextButton(
                  // 打開bottom sheet
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
                // 將slider撐到最大
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
                    onPressed: () {
                      _play();
                      // 若有設定重複播放：widget.state.repeatedTimes > 0
                      // 且重複播放還沒播完時：widget.state.repeatedTimes != _playedTimes
                      if (widget.state.repeatedTimes > 0 &&
                          widget.state.repeatedTimes != _playedTimes) {
                        setState(() {
                          // 可以開始重複播放
                          _holdPlay = false;
                          // 重複播放的第一次播放，播放次數加1
                          _playedTimes++;
                        });
                      }
                    },
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
    // 播放用的AssetsAudioPlayer物件
    _assetsAudioPlayer = AssetsAudioPlayer();
    // 偷跑一次open()獲得duration用的AssetsAudioPlayer物件
    _anotherAudioPlayer = AssetsAudioPlayer();
    // 監聽"_anotherAudioPlayer""目前播放歌曲"的stream，傳入一個playing物件
    _durationSubscription = _anotherAudioPlayer.current.listen((playingAudio) {
      setState(() {
        // 取得歌曲總長(Duration物件)
        _duration = playingAudio.audio.duration;
      });
    });
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
      // 這裡setState()就好了，其他地方不需要再設定PlayerState
      setState(() {
        _playerState = playState;
      });
      // 實作重複播放：
      // 1. 先檢查是否為PlayerState.stop
      if (_playerState == PlayerState.stop) {
        // 2. 如果有更新重複播放次數
        if (widget.state.repeatedTimes != null) {
          // 3. 且已播放次數小於重複播放次數
          if (_playedTimes < widget.state.repeatedTimes) {
            // 因為更新重複播放次數後會進入到PlayerState.stop的狀態，會自動播放
            // 所以要用_holdPlay控制是否播放
            // 該變數初始化時是false，更新重複播放次數時變true，按下play後再變成false
            // 這樣設條件目的是設定重複播放後一定要靠按下play才能播放第一次
            if (_holdPlay == false) {
              // 開始播放
              _play();
              // 進入這個條件式時已播放次數才會加1，但重複播放的第一次播放都是透過按play
              // 所以第一次加1要在play button的callback處理
              _playedTimes++;
            }
          }
        }
      }
      // 觀察PlayerState要在這裡print()
      // print('_playerState:${_playerState.toString()}');
    });

    // 監聽"播放結束時"的stream，傳入一個playing物件
    _playerFinishSubscription =
        _assetsAudioPlayer.playlistAudioFinished.listen((playingAudio) {
      // 此事件一觸發時會是PlayerState.pause，之後才會變成PlayerState.stop
      // 因此不好用！
    });
    // 監聽status的自訂stream
    _audioSettingStatusSubscription =
        widget.state.statusStreamController.stream.listen((status) {
      if (status == Status.accentUpdate ||
          status == Status.genderUpdate ||
          status == Status.rateUpdate) {
        // 更新時若是暫停狀態，要呼叫_stop，這裡先暫時不做特別檢查
        _stop();
        // 再初始化播放器(因為更新播放設定了)，url才會重新獲得
        _initAssetAudioPlayer();
      }
      // 特別檢查更新重複播放次數
      else if (status == Status.repeatedTimesUpdate) {
        setState(() {
          // 已播放次數歸零
          _playedTimes = 0;
          // 要讓播放器先不播放的變數(true)
          _holdPlay = true;
        });
        // 更新時若是暫停狀態，要呼叫_stop，這裡先暫時不做特別檢查
        _stop();
        // 再初始化播放器(因為更新播放設定了)，url才會重新獲得
        _initAssetAudioPlayer();
      }
    });
  }

  // 獲得歌曲時間的方法(先播放觸發stream後立刻stop)
  Future<void> _getDuration() async {
    // 檢查url字串不為空
    if (widget.url != null) {
      // 檢查PlayerState.stop
      if (_playerState == PlayerState.stop) {
        // 要使用_anotherAudioPlayer，不是_assetsAudioPlayer(因為要設定聲音為0)
        // 開始播放歌曲，才會觸發_anotherAudioPlayer.current這個stream，才能獲得歌曲時間
        await _anotherAudioPlayer.open(
          Audio.network(widget.url),
          // 設定聲音為0，確保在_stop()運作前不會讓使用者聽到聲音
          volume: 0.0,
        );
        // 觸發current stream後立刻呼叫_stop()，歌曲才不會真的播放
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
    // 內建的stop()方法不會馬上變成PlayerState.stop，但會停止播放
    await _assetsAudioPlayer.stop();
    setState(() {
      _position = Duration();
    });
  }
}
