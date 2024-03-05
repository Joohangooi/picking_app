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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomCard(
                  date: '2021-10-01',
                  pickedNo: 'NC002167',
                  companyName: 'Greenstem Sdn Bhd',
                  zone: 'Zone A',
                  option: 'c',
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomCard(
                  date: '2021-10-01',
                  pickedNo: 'NC002167',
                  companyName: 'Greenstem Sdn Bhd',
                  zone: 'Zone A',
                  option: 'c',
                ),
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
