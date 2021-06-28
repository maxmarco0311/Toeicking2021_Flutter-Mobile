class TimeString {
  // 靜態方法：回傳一小時以下的時間字串
  static String formatLessHour(Duration duration) {
    String finalText;
    // 取出duration字串的"分鐘"
    String minutePart =
        duration?.toString()?.split('.')?.first?.split(':')?.elementAt(1) ?? '';
    // 如第一個字元是'0'，則去掉
    if (minutePart != null && minutePart.length > 0) {
      if (minutePart.substring(0, 1) == '0') {
        minutePart = minutePart.substring(1);
      }
    }
    // 取出duration字串的"秒"
    String secondPart =
        duration?.toString()?.split('.')?.first?.split(':')?.elementAt(2) ?? '';
    finalText = '$minutePart:$secondPart';
    return finalText ?? '';
  }
}
