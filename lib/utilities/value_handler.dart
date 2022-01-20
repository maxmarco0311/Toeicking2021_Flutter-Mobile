class ValueHandler {
  static String toAccentImageUrl(String accent) {
    String imageUrl = '';
    switch (accent) {
      case 'US':
        imageUrl = 'assets/images/america.jpg';
        break;
      case 'GB':
        imageUrl = 'assets/images/britain.png';
        break;
      case 'AU':
        imageUrl = 'assets/images/australia.png';
        break;
      default:
        imageUrl = 'assets/images/test.jpg';
    }
    return imageUrl;
  }

  static String toGenderString(String gender) {
    String genderString = '';
    switch (gender) {
      case 'M':
        genderString = '男聲';
        break;
      case 'F':
        genderString = '女聲';
        break;
      default:
        genderString = '男聲';
    }
    return genderString;
  }

  static String toRateString(String rate) {
    String rateString = '';
    switch (rate) {
      case '0.75':
        rateString = '慢速(0.75x)';
        break;
      case '1.0':
        rateString = '正常(1.0x)';
        break;
      case '1.25':
        rateString = '快速(1.25x)';
        break;
      default:
        rateString = '正常(1.0x)';
    }
    return rateString;
  }
}
