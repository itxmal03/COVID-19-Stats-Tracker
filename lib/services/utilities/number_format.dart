import 'package:intl/intl.dart';

class NumberFormatter {
  static String format(double num) {
    final formatedNumber = NumberFormat('#,###');
    return formatedNumber.format(num);
  }
}
