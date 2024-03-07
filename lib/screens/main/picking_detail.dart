import 'package:flutter/material.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';
import 'package:picking_app/services/main_picking_service.dart'; // Import the service

class PickingDetailPage extends StatefulWidget {
  const PickingDetailPage();

  @override
  _PickingDetailPageState createState() => _PickingDetailPageState();
}

class _PickingDetailPageState extends State<PickingDetailPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingDetailData = [];

  @override
  void initState() {
    super.initState();
    fetchPickingDataFromLocalDb();
  }

  Future<void> fetchPickingDataFromLocalDb() async {
    final dbHelper = SqliteDbHelper();
    final pickingRecords = await dbHelper.getPickingRecords();

    setState(() {
      pickingDetailData =
          pickingRecords.map((record) => record.toJson()).toList();
      print(pickingDetailData);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget company_logos = const Image(
      width: 120,
      height: 120,
      image:
          AssetImage('assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'),
    );

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
            // Use ListView.builder to create cards from fetched data
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pickingDetailData.length,
              itemBuilder: (context, index) {
                final data = pickingDetailData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomCard(
                        pickedNo: data['documentNo'],
                        // stockCode: data['stock'],
                        // stockDesc: data['description'],
                        companyName: data['customerName'],
                        location: data['location'],
                        zone: data['zone'],
                        requestQty: data['requestQty'].toString(),
                        varianceQty: data['quantity'].toString(),
                        pickedQty: data['quantity'].toString(),
                        binNo: data['binShelfNo'],
                        // remarks: data['remarks'],
                        option: data['option'],
                        onTap: () {
                          print('Card tapped: ${data['documentNo']}');
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
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
