import 'package:intl/intl.dart';

class ExtensionDate {
  static String formatDateHomePage(DateTime date) {
    String suffix = '';
    int day = date.day;
    if (day == 1 || day == 21 || day == 31) {
      suffix = 'st';
    } else if (day == 2 || day == 22) {
      suffix = 'nd';
    } else if (day == 3 || day == 23) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    String formattedDay = DateFormat('E').format(date); // Lấy thứ
    return '$formattedDay, ${DateFormat('d\'$suffix\' MMMM yyyy').format(date)}';
  }

  static String formatDateReadPage(String inputDate) {
    // Phân tích chuỗi ngày thành đối tượng DateTime
    DateTime dateTime = DateTime.parse(inputDate);

    // Lấy ngày, tháng và năm
    int day = dateTime.day;
    int year = dateTime.year;

    // Xác định hậu tố của ngày
    String suffix = '';
    if (day == 1 || day == 21 || day == 31) {
      suffix = 'st';
    } else if (day == 2 || day == 22) {
      suffix = 'nd';
    } else if (day == 3 || day == 23) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    // Chuyển đổi tháng thành định dạng ngắn (ví dụ: "Jan", "Feb", ...)
    String monthAbbreviation = DateFormat('MMM').format(dateTime);

    // Tạo chuỗi định dạng ngày mới
    String formattedDate = '$day$suffix $monthAbbreviation $year';

    return formattedDate;
  }

  static String calculateTimeDifference(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'vừa xong';
    }
  }

  static String formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');
    String month = time.month.toString().padLeft(2, '0');
    String year = time.year.toString();

    return '$hour:$minute  $day/$month/$year';
  }
}
