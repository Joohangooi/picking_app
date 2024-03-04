import 'package:flutter/material.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';

class PickingMainPage extends StatefulWidget {
  @override
  _PickingMainPageState createState() => _PickingMainPageState();
}

class _PickingMainPageState extends State<PickingMainPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget company_logos = const Image(
        width: 120,
        height: 120,
        image: AssetImage(
            'assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'));

    return Scaffold(
      appBar: AppBarWidget(title: 'Greenstem'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SearchBarWidget(
                controller: searchController,
                onChanged: (value) {
                  // Handle search query changes
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomCard(
                subtitle: "Subtitle",
                pickedNo: "Picked No",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: company_logos,
            ),
          ],
        ),
      ),
    );
  }
}
