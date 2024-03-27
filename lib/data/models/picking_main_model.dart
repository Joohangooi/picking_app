class PickingMainModel {
  String? documentNo;
  DateTime? documentDate;
  DateTime? issueDate;
  String? remarks;
  String? customerName;
  String? pickBy;
  String? zone;
  DateTime? dateCompleted;
  String? issueBy;
  String? salesMan;
  String? option;
  String? generateTime;

  PickingMainModel({
    this.documentNo,
    this.documentDate,
    this.issueDate,
    this.remarks,
    this.customerName,
    this.pickBy,
    this.zone,
    this.issueBy,
    this.salesMan,
    this.dateCompleted,
    this.generateTime,
    this.option,
  });

  factory PickingMainModel.fromJson(Map<String, dynamic> json) {
    return PickingMainModel(
      documentNo: json['documentNo'] ?? '',
      documentDate: DateTime.tryParse(json['documentDate'] ?? ''),
      issueDate: DateTime.tryParse(json['issueDate'] ?? ''),
      remarks: json['remarks'] ?? '',
      customerName: json['customerName'] ?? '',
      pickBy: json['pickBy'] ?? '',
      zone: json['zone'] ?? '',
      issueBy: json['issueBy'] ?? '',
      salesMan: json['salesMan'] ?? '',
      dateCompleted: DateTime.tryParse(json['dateCompleted'] ?? ''),
      generateTime: json['generateTime'] ?? '',
      option: json['option'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentNo': documentNo,
      'documentDate': documentDate?.toString(),
      'issueDate': issueDate?.toString(),
      'remarks': remarks,
      'customerName': customerName,
      'pickBy': pickBy,
      'zone': zone,
      'issueBy': issueBy,
      'salesMan': salesMan,
      'generateTime': generateTime ?? '',
      'dateCompleted': dateCompleted?.toString(),
      'option': option,
    };
  }
}
