abstract class BaseLocalDataRepository {
  Future<int> insertLocalAudioSettingState(Map<String, dynamic> map);
  Future<Map<String, dynamic>> getLocalAudioSettingState();
  Future<int> updateLocalAudioSettingState(Map<String, dynamic> map);
}
