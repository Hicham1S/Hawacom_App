// Additional user data for more realistic testing

class DummyUser {
  final String name;
  final int followers;
  final int following;
  final bool isVerified;

  DummyUser({
    required this.name,
    required this.followers,
    required this.following,
    this.isVerified = false,
  });
}

class DummyUsers {
  static List<DummyUser> getUsers() {
    return [
      DummyUser(
        name: 'أمينة الهاجري',
        followers: 12500,
        following: 450,
        isVerified: true,
      ),
      DummyUser(
        name: 'أحمد الشهري',
        followers: 8900,
        following: 320,
        isVerified: true,
      ),
      DummyUser(
        name: 'فاطمة العتيبي',
        followers: 5600,
        following: 180,
      ),
      DummyUser(
        name: 'محمد الدوسري',
        followers: 15000,
        following: 890,
        isVerified: true,
      ),
      DummyUser(
        name: 'سارة المالكي',
        followers: 7800,
        following: 420,
      ),
      DummyUser(
        name: 'نورة القحطاني',
        followers: 23000,
        following: 650,
        isVerified: true,
      ),
      DummyUser(
        name: 'خالد العنزي',
        followers: 11200,
        following: 530,
        isVerified: true,
      ),
      DummyUser(
        name: 'ريم الزهراني',
        followers: 9400,
        following: 290,
      ),
      DummyUser(
        name: 'عبدالله الغامدي',
        followers: 6700,
        following: 210,
      ),
      DummyUser(
        name: 'يوسف الحربي',
        followers: 18500,
        following: 720,
        isVerified: true,
      ),
    ];
  }

  static List<String> getArabicNames() {
    return [
      'أمينة الهاجري',
      'أحمد الشهري',
      'فاطمة العتيبي',
      'محمد الدوسري',
      'سارة المالكي',
      'نورة القحطاني',
      'خالد العنزي',
      'ريم الزهراني',
      'عبدالله الغامدي',
      'يوسف الحربي',
      'منى السبيعي',
      'عمر القرني',
      'لينا العمري',
      'فهد المطيري',
      'هند الشمري',
    ];
  }

  static List<String> getCities() {
    return [
      'الرياض',
      'جدة',
      'مكة',
      'المدينة',
      'الدمام',
      'الخبر',
      'الطائف',
      'تبوك',
      'بريدة',
      'أبها',
      'الجبيل',
      'حائل',
      'نجران',
      'ينبع',
      'الأحساء',
    ];
  }
}
