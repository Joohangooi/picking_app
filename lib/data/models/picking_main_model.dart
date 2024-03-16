class PickingMainModel {
  String? documentNo;
  DateTime? documentDate;
  DateTime? issueDate;
  String? remarks;
  String? customerName;
  String? pickBy;
  String? zone;
  DateTime? dateCompleted;
  String? option;

  PickingMainModel({
    this.documentNo,
    this.documentDate,
    this.issueDate,
    this.remarks,
    this.customerName,
    this.pickBy,
    this.zone,
    this.dateCompleted,
    this.option,
  });

  factory PickingMainModel.fromJson(Map<String, dynamic> json) {
    return PickingMainModel(
      documentNo: json['documentNo'],
      documentDate: DateTime.tryParse(json['documentDate']),
      issueDate: DateTime.tryParse(json['issueDate']),
      remarks: json['remarks'],
      customerName: json['customerName'],
      pickBy: json['pickBy'],
      zone: json['zone'],
      dateCompleted: DateTime.tryParse(json['dateCompleted']),
      option: json['option'],
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
      'dateCompleted': dateCompleted?.toString(),
      'option': option,
    };
  }
}
