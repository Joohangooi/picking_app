import 'package:flutter/material.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';

class PickingMainPage extends StatefulWidget {
  @override
  _PickingMainPageState createState() => _PickingMainPageState();
}

class _PickingMainPageState extends State<PickingMainPage> {
  @override
  Widget build(BuildContext context) {
    Widget company_logos = const Image(
        width: 120,
        height: 120,
        image: AssetImage(
            'assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'));

    return Scaffold(
        appBar: AppBarWidget(title: 'Greenstem'), body: company_logos);
  }
}
