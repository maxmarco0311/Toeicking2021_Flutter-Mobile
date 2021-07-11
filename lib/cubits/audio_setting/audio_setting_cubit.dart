import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/repositories.dart';
part 'audio_setting_state.dart';

class AudioSettingCubit extends Cubit<AudioSettingState> {
  // 此cubit會用到的repository：
  final LocalDataRepository _localDataRepository;
  final APIRepository _apiRepository;
  // cubit建構式
  AudioSettingCubit({
    @required LocalDataRepository localDataRepository,
    @required APIRepository apiRepository,
  })  : _localDataRepository =
            localDataRepository ?? LocalDataRepository.instance,
        _apiRepository = apiRepository ?? APIRepository.instance,
        super(
          // 初始的state資料，會被getLocalAudioSettingState()所獲得的資料蓋過去
          AudioSettingState.initial(),
        );
  // cubit一在頁面建立時就要呼叫的方法，取出sqlite現存的資料來更新狀態
  void getLocalAudioSettingState() async {
    print('getLocalAudioSettingState called!');
    // 因為此方法是非同步操作，所以一進入此方法時，先將status改為initStateLoading
    // UI可做對應的顯示
    emit(state.copyWith(status: Status.initStateLoading));
    Map<String, dynamic> localAudioSettingState =
        await _localDataRepository.getLocalAudioSettingState();
    print('頁面建立時取得的sqlite：${localAudioSettingState.toString()}');
    if (localAudioSettingState != null) {
      // 已取得sqlite資料並更新狀態，同時再將status改為initStateLoaded
      // UI可做對應的顯示
      emit(
        state.copyWith(
            accent: localAudioSettingState['accent'],
            gender: localAudioSettingState['gender'],
            rate: localAudioSettingState['rate'],
            repeatedTimes: localAudioSettingState['repeatedTimes'],
            status: Status.initStateLoaded),
      );
      print('從sqlite更新的狀態：${state.toString()}');
    } else {
      // 若從sqlite裡撈不到資料，就將status換成failure
      emit(state.copyWith(status: Status.failure));
    }
  }

  void updateAccent({
    @required String accent,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) async {
    statusStreamController.sink.add(status);
    // 更新state
    emit(
      state.copyWith(
        accent: accent,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
    // 更新sqlite
    try {
      // 不能用final，因為要再賦值
      LocalAudioSettingState localAudioState =
          await getCurrentLocalAudioState();
      if (localAudioState != null) {
        // 不可以單獨使用copyWith()，要再賦值給物件
        localAudioState = localAudioState.copyWith(accent: accent);
        await _localDataRepository
            .updateLocalAudioSettingState(localAudioState.toMap());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void updateGender({
    @required String gender,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) async {
    statusStreamController.sink.add(status);
    emit(
      state.copyWith(
        gender: gender,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
    // 更新sqlite
    try {
      // 不能用final，因為要再賦值
      LocalAudioSettingState localAudioState =
          await getCurrentLocalAudioState();
      if (localAudioState != null) {
        // 不可以單獨使用copyWith()，要再賦值給物件
        localAudioState = localAudioState.copyWith(gender: gender);
        await _localDataRepository
            .updateLocalAudioSettingState(localAudioState.toMap());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void updateRate({
    @required String rate,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) async {
    statusStreamController.sink.add(status);
    emit(
      state.copyWith(
        rate: rate,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
    // 更新sqlite
    try {
      // 不能用final，因為要再賦值
      LocalAudioSettingState localAudioState =
          await getCurrentLocalAudioState();
      if (localAudioState != null) {
        // 不可以單獨使用copyWith()，要再賦值給物件
        localAudioState = localAudioState.copyWith(rate: rate);
        await _localDataRepository
            .updateLocalAudioSettingState(localAudioState.toMap());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void updateRepeatedTimes({
    @required int repeatedTimes,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) async {
    statusStreamController.sink.add(status);
    // 一更新重複撥放次數，已播放次數就要歸零
    emit(
      state.copyWith(
        repeatedTimes: repeatedTimes,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
    // 更新sqlite
    try {
      // 不能用final，因為要再賦值
      LocalAudioSettingState localAudioState =
          await getCurrentLocalAudioState();
      if (localAudioState != null) {
        // 不可以單獨使用copyWith()，要再賦值給物件
        localAudioState =
            localAudioState.copyWith(repeatedTimes: repeatedTimes);
        await _localDataRepository
            .updateLocalAudioSettingState(localAudioState.toMap());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  // 獲得sqlite裡目前的LocalAudioSettingState物件(目前存的那一筆資料)
  Future<LocalAudioSettingState> getCurrentLocalAudioState() async {
    final localAudioStateMap =
        await _localDataRepository.getLocalAudioSettingState();
    final localAudioState = LocalAudioSettingState.fromMap(localAudioStateMap);
    return localAudioState;
  }

  // 測試API用的方法
  Future<User> updateUser({@required User user}) async {
    return await _apiRepository.updateUser(user: user);
  }

  // 測試API用的方法
  Future<User> addWordList({
    @required String email,
    @required String vocabularyId,
  }) async {
    return await _apiRepository.addWordList(
      email: email,
      vocabularyId: vocabularyId,
    );
  }

  // 測試API用的方法
  Future<User> addUser({@required User user}) async {
    return await _apiRepository.addUser(user: user);
  }

  // 測試API用的方法
  Future<User> getUser({@required String email}) async {
    return await _apiRepository.getUser(email: email);
  }

  // 測試API用的方法
  Future<SentenceBundle> getSentenceBundleByVocabularyId(
      {String email, String vocabularyId}) async {
    return await _apiRepository.getSentenceBundleByVocabularyId(
      email: email,
      vocabularyId: vocabularyId,
    );
  }
}
