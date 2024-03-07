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
  final String? option;
  final VoidCallback? onTap;
  final IconButton? actionButton;

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
    this.option,
    this.onTap,
    this.actionButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String optionText;

    switch (option?.toLowerCase()) {
      case 'c':
        backgroundColor = Colors.green;
        optionText = 'Complete';
        break;
      case 'p':
        backgroundColor = Colors.orange;
        optionText = 'Partial';
        break;
      case 'x':
        backgroundColor = Colors.grey;
        optionText = 'Incomplete';
        break;
      case 't':
        backgroundColor = Colors.red;
        optionText = 'Taken';
        break;
      default:
        backgroundColor = Colors.transparent;
        optionText = '';
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 25.0, 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pickedNo != null)
                        Text(pickedNo!,
                            style: const TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            )),
                      if (companyName != null)
                        Text(companyName!,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      if (stockCode != null)
                        Text('Stock Code:${stockCode!}',
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      if (stockDesc != null)
                        Text(stockDesc!, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (date != null)
                              Text(date!, style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (zone != null)
                              Text('Zone ${zone!}',
                                  style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (location != null)
                              Text('Location: ${location!}',
                                  style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (binNo != null)
                              Text('Bin: ${binNo!}',
                                  style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      if (location != null &&
                          binNo != null &&
                          requestQty != null)
                        const SizedBox(width: 16.0),
                      if (location != null &&
                          binNo != null &&
                          requestQty != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (pickedQty != null)
                                if (requestQty != null)
                                  Text('Request Qty: ${requestQty!}',
                                      style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 3),
                              if (varianceQty != null)
                                Text('Variance Qty: ${varianceQty!}',
                                    style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 3),
                              Text(
                                'Picked Qty: ${pickedQty!}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: (requestQty != varianceQty)
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(8.0)),
                ),
                child: Text(
                  optionText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 3,
              child: actionButton ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
