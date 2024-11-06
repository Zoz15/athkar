class AppImages {
  static const String backgroundPath = 'assets/images/mashged/';
  static const String clickerPath = 'assets/images/clicker/';
  static const String replayIcon = 'assets/images/replay.png';
  static const String chickIcon = 'assets/images/chick.png';

  static List<String> backgroundImages = List.generate(
    9, 
    (index) => '$backgroundPath${index + 1}.png'
  );

  static List<String> clickerImages = List.generate(
    8, 
    (index) => '$clickerPath${index + 1}.png'
  );
}

class AppStrings {
  static const String appTitle = 'Tasbeeh Counter';
  static const String congratulations = 'مبروك!';
  static const String completedDhikr = 'لقد أكملت الذكر';
  static const String ok = 'حسناً';
  static const String selectDhikr = 'اختر الذكر';
  static const String addDhikr = 'إضافة ذكر جديد';
}

class AppDimensions {
  static const double defaultPadding = 16.0;
  static const double borderRadius = 15.0;
  static const double counterSize = 250.0;
}
