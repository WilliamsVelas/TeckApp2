class Payment {
  int? id;
  int invoiceId;
  int paymentMethodId; // Reemplaza 'method' por 'paymentMethodId'
  double amount;
  int createdAt;

  Payment({
    this.id,
    required this.invoiceId,
    required this.paymentMethodId,
    required this.amount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'paymentMethodId': paymentMethodId,
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int?,
      invoiceId: map['invoiceId'] as int,
      paymentMethodId: map['paymentMethodId'] as int,
      amount: map['amount'] as double,
      createdAt: map['createdAt'] as int,
    );
  }
}