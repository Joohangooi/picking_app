import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final String? issueBy;
  final String? remarks;
  final String? salesMan;
  final String? time;
  final VoidCallback? onTap;
  final IconButton? actionButton;
  final ValueChanged<String>? onLongPress;

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
    this.issueBy,
    this.salesMan,
    this.option,
    this.onTap,
    this.time,
    this.actionButton,
    this.remarks,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String optionText;
    DateTime? parsedDate;
    String formattedDate = '';

    if (date != null) {
      parsedDate = DateFormat('yyyy-MM-dd').parse(date!);
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate!);
    }
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

    String _formatTime(String time) {
      try {
        // Trim any leading or trailing whitespace
        String trimmedTime = time.trim();

        // Ensure the time string is not empty
        if (trimmedTime.isEmpty) {
          return ''; // Return empty string if time string is empty
        }

        // Parse the time string
        DateTime parsedTime = DateFormat('HH:mm').parse(trimmedTime);

        // Format the time into 12-hour format with AM/PM
        String formattedTime = DateFormat('h:mm a').format(parsedTime);

        return formattedTime;
      } catch (e) {
        print('Error formatting time: $e');
        return ''; // Return empty string if there's an error parsing/formatting the time
      }
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        if (onLongPress != null && requestQty != null) {
          onLongPress!(requestQty!);
        }
      },
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
                      if (remarks != null && remarks != "")
                        Text('Remark: ${remarks!}',
                            style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.deepPurple[600])),
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
                            if (formattedDate != '' || time != null)
                              Row(
                                children: [
                                  if (formattedDate != '')
                                    Text(
                                      formattedDate!,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  if (formattedDate != '' && time != null)
                                    const SizedBox(width: 8),
                                  if (time != null)
                                    Text(
                                      _formatTime(time!),
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                ],
                              ),
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
                            if (issueBy != null && issueBy != "")
                              Text('Issue By: $issueBy',
                                  style: const TextStyle(fontSize: 13.5)),
                            if (salesMan != null && salesMan != "")
                              Text('Salesman: $salesMan',
                                  style: const TextStyle(fontSize: 13.5)),
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
                              Text('Request Qty: ${requestQty!}',
                                  style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 3),
                              Text(
                                'Picked Qty: ${pickedQty!}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text('Variance Qty: ${varianceQty!}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: (varianceQty != "0")
                                        ? Colors.red
                                        : Colors.green[700],
                                  )),
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
