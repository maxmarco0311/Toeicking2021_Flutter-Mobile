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

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/local_audioSetting.db';
    final localAudioSettingDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return localAudioSettingDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $audioSettingTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnAccent TEXT, $columnGender TEXT, $columnRate TEXT, $columnRepeatedTimes INTEGER)');
  }

  @override
  Future<Map<String, dynamic>> getLocalAudioSettingState() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(audioSettingTable);
    // print(result.toString());
    // 檢查是否為空集合
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  @override
  Future<int> insertLocalAudioSettingState(Map<String, dynamic> map) async {
    Database db = await this.db;
    final int result = await db.insert(audioSettingTable, map);
    return result;
  }

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
