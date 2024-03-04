import 'package:flutter/material.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';

class PickingMainPage extends StatefulWidget {
  @override
  _PickingMainPageState createState() => _PickingMainPageState();
}

class _PickingMainPageState extends State<PickingMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Greenstem'),
      body: const Center(
        child: Text(
          'Greenstem ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
