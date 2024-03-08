import 'package:flutter/material.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/screens/main/picking_edit.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';

class PickingDetailPage extends StatefulWidget {
  final List<PickingModel> pickingData;
  const PickingDetailPage({super.key, required this.pickingData});

  @override
  _PickingDetailPageState createState() => _PickingDetailPageState();
}

class _PickingDetailPageState extends State<PickingDetailPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingDetailData = [];
  List<Map<String, dynamic>> filteredPickingData = [];

  @override
  void initState() {
    super.initState();
    pickingDetailData =
        widget.pickingData.map((record) => record.toJson()).toList();
    filteredPickingData = List.from(pickingDetailData);
  }

  void fetchLatestData() async {
    List<Map<String, dynamic>> latestData =
        await SqliteDbHelper.getLatestData(widget.pickingData.first.documentNo);
    setState(() {
      pickingDetailData = latestData;
      filteredPickingData = List.from(pickingDetailData);
    });
  }

  void filterPickingData(String query) {
    setState(() {
      if (query.isEmpty) {
        print("Empty query here");
        filteredPickingData = List.from(pickingDetailData);
      } else {
        filteredPickingData = pickingDetailData
            .where((item) =>
                item['documentNo']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                item['customerName']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ('Zone ${item['zone']}'
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
                item['location'].toLowerCase().contains(query.toLowerCase()) ||
                item['binShelfNo'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
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
      appBar: AppBarWidget(
        title: widget.pickingData.isNotEmpty
            ? widget.pickingData.first.customerName
            : 'Picking List',
        actionButton: IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () async {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SearchBarWidget(
                controller: searchController,
                onChanged: (value) {
                  filterPickingData(value);
                },
              ),
            ),
            // Use ListView.builder to create cards from fetched data
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredPickingData.length,
              itemBuilder: (context, index) {
                final data = filteredPickingData[index];
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
                        stockCode: data['stock'],
                        stockDesc: data['description'],
                        location: data['location'],
                        zone: data['zone'],
                        requestQty: data['requestQty'].toString(),
                        varianceQty:
                            (data['requestQty'] - data['quantity']).toString(),
                        pickedQty: data['quantity'].toString(),
                        binNo: data['binShelfNo'],
                        // remarks: data['remarks'],
                        option: data['option'],
                        actionButton: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PickingDetailEdit(
                                  pickingData: data,
                                  onSuccess: fetchLatestData,
                                ),
                              ),
                            );
                          },
                        ),

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
