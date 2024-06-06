class ExtensionTime {
  static String convertMinutesToTime(int minutes) {
    if (minutes < 60) {
      return '$minutes mins';
    } else if (minutes < 1440) {
      // 1440 minutes = 1 day
      int hours = minutes ~/ 60;
      return '$hours hours';
    } else {
      int days = minutes ~/ 1440;
      return '$days days';
    }
  }
}
