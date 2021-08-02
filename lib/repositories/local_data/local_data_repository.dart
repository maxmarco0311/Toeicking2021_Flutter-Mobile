import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'base_local_data_repository.dart';

class LocalDataRepository extends BaseLocalDataRepository {
  static final LocalDataRepository instance = LocalDataRepository._instance();
  LocalDataRepository._instance();
  static Database _db;
  String audioSettingTable = 'audioSetting_table';
  String columnId = 'id';
  String columnAccent = 'accent';
  String columnGender = 'gender';
  String columnRate = 'rate';
  String columnRepeatedTimes = 'repeatedTimes';

  // 取得sqlite db實體
  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  // 初始化db實體
  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/local_audioSetting.db';
    final localAudioSettingDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return localAudioSettingDb;
  }

  // 建立資料表，也要設一個對應資料表的類別LocalAudioSettingState，才可把資料存取給程式使用
  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $audioSettingTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnAccent TEXT, $columnGender TEXT, $columnRate TEXT, $columnRepeatedTimes INTEGER)');
  }

  // 從db取得播放設定值
  @override
  Future<Map<String, dynamic>> getLocalAudioSettingState() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(audioSettingTable);
    // print(result.toString());
    // 檢查是否為空集合
    if (result.isNotEmpty) {
      // 取資料表的第一筆
      return result.first;
    } else {
      return {};
    }
  }

  // 將播放設定初始值寫入db
  // 在auth_repository裡的signUpWithEmailAndPassword()裡呼叫
  @override
  Future<int> insertLocalAudioSettingState(Map<String, dynamic> map) async {
    Database db = await this.db;
    final int result = await db.insert(audioSettingTable, map);
    return result;
  }

  // 更新db中的播放設定值
  // 在audio setting cubit所有更新方法內呼叫
  @override
  Future<int> updateLocalAudioSettingState(Map<String, dynamic> map) async {
    Database db = await this.db;
    final int result = await db.update(
      audioSettingTable,
      map,
      // ?代表參數寫法，防範sql injection
      where: '$columnId = ?',
      // 參數值放在dynamic集合裡，要按照順序
      whereArgs: [map['id']],
    );
    return result;
  }
}
