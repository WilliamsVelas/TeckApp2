class SalesReport {
  final String documentNo;
  final int invoiceDate;
  final String productName;
  final double productPrice;
  final int qty;
  final String productSerial;
  final double lineTotal;

  SalesReport({
    required this.documentNo,
    required this.invoiceDate,
    required this.productName,
    required this.productPrice,
    required this.qty,
    required this.productSerial,
    required this.lineTotal,
  });
}