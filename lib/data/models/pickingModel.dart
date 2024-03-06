class PickingModel {
  final int id;
  final String date;
  final String pickedNo;
  final String companyName;
  final String zone;
  final String remarks;
  final String option;
  final double quantity;
  final double requestQty;

  PickingModel({
    required this.id,
    required this.date,
    required this.pickedNo,
    required this.companyName,
    required this.zone,
    required this.remarks,
    required this.option,
    required this.quantity,
    required this.requestQty,
  });

  factory PickingModel.fromJson(Map<String, dynamic> json) {
    return PickingModel(
      id: json['id'] ?? 0,
      date: json['documentDate'] ?? '',
      pickedNo: json['documentNo'] ?? '',
      companyName: json['customerName'] ?? '',
      zone: json['zone'] ?? '',
      remarks: json['remarks'] ?? '',
      option: json['option'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      requestQty: (json['requestQty'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentDate': date,
      'documentNo': pickedNo,
      'customerName': companyName,
      'zone': zone,
      'remarks': remarks,
      'option': option,
      'quantity': quantity,
      'requestQty': requestQty,
    };
  }
}
