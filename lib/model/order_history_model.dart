class OrderHistory {
  final String orderID;
  final int laundryStatus;

  OrderHistory({
    required this.orderID,
    required this.laundryStatus,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      orderID: json['orderID'],
      laundryStatus: json['laundryStatus'],
    );
  }
}
