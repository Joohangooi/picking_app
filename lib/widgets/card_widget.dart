import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
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
  final bool showCheckbox;

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
    required this.showCheckbox,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String optionText;

    switch (widget.option?.toLowerCase()) {
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
      onTap: widget.onTap,
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 25.0, 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showCheckbox)
                        SizedBox(
                          width: 15.0, // Adjust the width as needed
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                          ),
                        ),
                      const SizedBox(width: 18.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.pickedNo != null)
                              Text(widget.pickedNo!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  )),
                            if (widget.companyName != null)
                              Text(widget.companyName!,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            if (widget.stockCode != null)
                              Text('Stock Code:${widget.stockCode!}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            if (widget.stockDesc != null)
                              Text(widget.stockDesc!,
                                  style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
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
                            if (widget.date != null)
                              Text(widget.date!,
                                  style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (widget.zone != null)
                              Text('Zone ${widget.zone!}',
                                  style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (widget.location != null)
                              Text('Location: ${widget.location!}',
                                  style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 3),
                            if (widget.binNo != null)
                              Text('Bin: ${widget.binNo!}',
                                  style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      if (widget.location != null &&
                          widget.binNo != null &&
                          widget.requestQty != null)
                        const SizedBox(width: 16.0),
                      if (widget.location != null &&
                          widget.binNo != null &&
                          widget.requestQty != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Request Qty: ${widget.requestQty!}',
                                  style: const TextStyle(fontSize: 15)),
                              const SizedBox(height: 3),
                              Text(
                                'Picked Qty: ${widget.pickedQty!}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text('Variance Qty: ${widget.varianceQty!}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: (widget.varianceQty != "0.0")
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
              child: widget.actionButton ?? Container(),
            ),
          ],
        ),
      ),
    );
  }
}
