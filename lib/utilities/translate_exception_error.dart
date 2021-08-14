class TranslateExceptionError {
  // 登入或註冊錯誤
  static String authException(String code) {
    String chineseErrorMessage;
    switch (code) {
      // 登入
      case 'ERROR_INVALID_EMAIL':
        chineseErrorMessage = '無效的電子郵件';
        break;
      case 'wrong-password':
        chineseErrorMessage = '密碼錯誤';
        break;
      case 'user-not-found':
        chineseErrorMessage = '無此用戶';
        break;
      case 'user-disabled':
        chineseErrorMessage = '用戶已停權';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        chineseErrorMessage = '出現無法預期的錯誤，請再試一次';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        chineseErrorMessage = '出現無法預期的錯誤，請再試一次';
        break;
      // 註冊
      case 'ERROR_WEAK_PASSWORD':
        chineseErrorMessage = '密碼強度太弱';
        break;
      case 'email-already-in-use':
        chineseErrorMessage = '此電子郵件已註冊';
        break;
      case 'ERROR_INVALID_CREDENTIAL':
        chineseErrorMessage = '無效的電子郵件';
        break;
      default:
        chineseErrorMessage = '出現無法預期的錯誤，請再試一次';
    }
    return chineseErrorMessage;
  }

  // 平台錯誤
  static String platformException(String code) {
    String chineseErrorMessage;
    // Android要看message屬性，iOS要看code屬性
    switch (code) {
      // Android
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        chineseErrorMessage = '無此用戶';
        break;
      case 'The password is invalid or the user does not have a password.':
        chineseErrorMessage = '密碼無效';
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        chineseErrorMessage = '網路出現錯誤';
        break;
      // iOS
      case 'Error 17011':
        chineseErrorMessage = '無此用戶';
        break;
      case 'Error 17009':
        chineseErrorMessage = '密碼無效';
        break;
      case 'Error 17020':
        chineseErrorMessage = '網路出現錯誤';
        break;
      default:
        chineseErrorMessage = '出現無法預期的錯誤，請再試一次';
    }
    return chineseErrorMessage;
  }
}
