class PickingModel {
  final String documentNo;
  final String documentDate;
  final String pickedNo;
  final String customerName;
  final String zone;
  final String remarks;
  final String option;
  final String description;
  final String stock;
  final String location;
  final String binShelfNo;
  final double quantity;
  final double requestQty;
  final String? salesMan;
  final String? issueBy;
  final int line;

  PickingModel({
    required this.documentNo,
    required this.documentDate,
    required this.pickedNo,
    required this.customerName,
    required this.zone,
    required this.remarks,
    required this.option,
    required this.description,
    required this.stock,
    required this.location,
    required this.binShelfNo,
    required this.quantity,
    required this.requestQty,
    this.salesMan,
    this.issueBy,
    required this.line,
  });

  factory PickingModel.fromJson(Map<String, dynamic> json) {
    return PickingModel(
      documentDate: json['documentDate'] ?? '',
      documentNo: json['documentNo'] ?? '',
      customerName: json['customerName'] ?? '',
      zone: json['zone'] ?? '',
      remarks: json['remarks'] ?? '',
      location: json['location'] ?? '',
      option: json['option'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      binShelfNo: json['binShelfNo'] ?? '',
      description: json['description'] ?? '',
      stock: json['stock'] ?? '',
      requestQty: (json['requestQty'] ?? 0).toDouble(),
      issueBy: json['issueBy'] ?? '',
      salesMan: json['salesMan'] ?? '',
      pickedNo: json['pickedNo'] ?? '',
      line: json['line'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNo': pickedNo,
      'documentDate': documentDate,
      'customerName': customerName,
      'stock': stock,
      'pickedNo': pickedNo,
      'zone': zone,
      'location': location,
      'remarks': remarks,
      'option': option,
      'quantity': quantity,
      'binShelfNo': binShelfNo,
      'description': description,
      'issueBy': issueBy,
      'salesMan': salesMan,
      'requestQty': requestQty,
      'line': line,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'documentNo': documentNo,
      'documentDate': documentDate,
      'customerName': customerName,
      'stock': stock,
      'pickedNo': pickedNo,
      'zone': zone,
      'location': location,
      'remarks': remarks,
      'option': option,
      'quantity': quantity,
      'binShelfNo': binShelfNo,
      'issueBy': issueBy,
      'salesMan': salesMan,
      'description': description,
      'requestQty': requestQty,
      'line': line,
    };
  }
}
