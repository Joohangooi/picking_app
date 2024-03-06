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
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (date != null)
                          Text(date!, style: const TextStyle(fontSize: 15)),
                        if (pickedNo != null)
                          Text(pickedNo!, style: const TextStyle(fontSize: 15)),
                        if (companyName != null)
                          Text(companyName!,
                              style: const TextStyle(fontSize: 15)),
                        if (zone != null)
                          Text('Zone ' + zone!,
                              style: const TextStyle(fontSize: 15)),
                        if (stockCode != null)
                          Text(stockCode!,
                              style: const TextStyle(fontSize: 15)),
                        if (stockDesc != null)
                          Text(stockDesc!,
                              style: const TextStyle(fontSize: 15)),
                        if (location != null)
                          Text(location!, style: const TextStyle(fontSize: 15)),
                        if (requestQty != null)
                          Text(requestQty!,
                              style: const TextStyle(fontSize: 15)),
                        if (varianceQty != null)
                          Text(varianceQty!,
                              style: const TextStyle(fontSize: 15)),
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
                          if (binNo != null)
                            Text(binNo!, style: const TextStyle(fontSize: 15)),
                          if (pickedQty != null)
                            Text(pickedQty!,
                                style: const TextStyle(fontSize: 15)),
                        ],
                      ),
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
              right: 5,
              child: location != null && binNo != null && requestQty != null
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        print('Edit clicked!');
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        print('Bin clicked!');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
