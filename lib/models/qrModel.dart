class QRCodeData {
  final String agency;
  final String currency;
  final String rate;
  final String amount;
  final String total;
  final String dateReserva;
  final String subAgencyReserva;
  final String payReserva;

  QRCodeData(
      {required this.agency,
      required this.currency,
      required this.rate,
      required this.amount,
      required this.total,
      required this.dateReserva,
      required this.subAgencyReserva,
      required this.payReserva});

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      agency: json['Agency'],
      currency: json['Currency'],
      rate: json['Rate'],
      amount: json['Amount'],
      total: json['Total'],
      dateReserva: json['Date'],
      subAgencyReserva: json['SubAgency'],
      payReserva: json['Pay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Agency': agency,
      'Currency': currency,
      'Rate': rate,
      'Amount': amount,
      'Total': total,
      'Date': dateReserva,
      'SubAgency': subAgencyReserva,
      'Pay': payReserva,
    };
  }
}
