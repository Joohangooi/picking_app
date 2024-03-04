import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? date;
  final String? pickedNo;
  final String? zone;

  const CustomCard({
    this.title,
    this.subtitle,
    this.date,
    this.pickedNo,
    this.zone,
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
                    if (title != null) Text(title!),
                    if (subtitle != null) Text(subtitle!),
                    if (subtitle != null) Text(subtitle!),
                  ],
                ),
              ),
              const SizedBox(width: 16.0), // Add spacing between columns
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (title != null) Text(title!),
                    if (subtitle != null) Text(subtitle!),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
