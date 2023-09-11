import 'package:intl/intl.dart';

formatRupiah(nominal) {
  double value = nominal;

  // Create a NumberFormat instance for currency formatting in Indonesian Rupiah
  NumberFormat rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0, // Display as whole numbers
  );

  String formattedValue = rupiahFormat.format(value);
  return formattedValue;
}
