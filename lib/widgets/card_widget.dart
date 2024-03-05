import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? date;
  final String? pickedNo;
  final String? companyName;
  final String? zone;
  final String? stockCode;
  final String? stockDesc;
  final String? location;
  final String? requestQty;
  final String? varianceQty;
  final String? binNo;
  final String? pickedQty;

  const CustomCard({
    this.date,
    this.pickedNo,
    this.companyName,
    this.zone,
    this.stockCode,
    this.stockDesc,
    this.location,
    this.requestQty,
    this.varianceQty,
    this.binNo,
    this.pickedQty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          // Define the action you want to perform when the card is clicked
          print('Card clicked!'); // For example, print a message
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (date != null) Text(date!),
                    if (pickedNo != null) Text(pickedNo!),
                    if (companyName != null) Text(companyName!),
                    if (zone != null) Text(zone!),
                    if (stockCode != null) Text(stockCode!),
                    if (stockDesc != null) Text(stockDesc!),
                    if (location != null) Text(location!),
                    if (requestQty != null) Text(requestQty!),
                    if (varianceQty != null) Text(varianceQty!),
                  ],
                ),
              ),
              if (location != null && binNo != null && requestQty != null)
                const SizedBox(width: 16.0),
              if (location != null && binNo != null && requestQty != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (binNo != null) Text(binNo!),
                      if (pickedQty != null) Text(pickedQty!),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
