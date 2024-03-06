class PickingModel {
  int? id;
  final String date;
  final String pickedNo;
  final String companyName;
  final String zone;
  final String remarks;
  final String option;
  final String binShelfNo;
  final String description;
  final double quantity;
  final double requestQty;

  PickingModel({
    this.id,
    required this.date,
    required this.pickedNo,
    required this.companyName,
    required this.zone,
    required this.remarks,
    required this.option,
    required this.quantity,
    required this.requestQty,
    required this.binShelfNo,
    required this.description,
  });

  factory PickingModel.fromJson(Map<String, dynamic> json) {
    return PickingModel(
      date: json['documentDate'] ?? '',
      pickedNo: json['documentNo'] ?? '',
      companyName: json['customerName'] ?? '',
      zone: json['zone'] ?? '',
      remarks: json['remarks'] ?? '',
      option: json['option'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      binShelfNo: json['binShelfNo'] ?? '',
      description: json['description'] ?? '',
      requestQty: (json['requestQty'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentNo': pickedNo,
      'documentDate': date,
      'customerName': companyName,
      'zone': zone,
      'remarks': remarks,
      'option': option,
      'quantity': quantity,
      'binShelfNo': binShelfNo,
      'description': description,
      'requestQty': requestQty,
    };
  }
}
