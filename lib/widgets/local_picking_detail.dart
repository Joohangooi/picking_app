import 'package:flutter/material.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/widgets/card_widget.dart';

class LocalPickingDetail extends StatefulWidget {
  const LocalPickingDetail({Key? key}) : super(key: key);

  @override
  _LocalPickingState createState() => _LocalPickingState();
}

class _LocalPickingState extends State<LocalPickingDetail> {
  List<Map<String, dynamic>> pickingDetailData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call the API when the page loads
    fetchPickingDataFromLocalDb();
  }

  Future<void> fetchPickingDataFromLocalDb() async {
    final pickingRecords = await SqliteDbHelper.getAllRecords();

    setState(() {
      pickingDetailData =
          pickingRecords.map((record) => record.toJson()).toList();
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CustomCard(
                              pickedNo: data['documentNo'],
                              stockCode: data['stock'],
                              stockDesc: data['description'],
                              location: data['location'],
                              zone: data['zone'],
                              requestQty: data['requestQty'].toString(),
                              varianceQty:
                                  (data['requestQty'] - data['quantity'])
                                      .toString(),
                              pickedQty: data['quantity'].toString(),
                              binNo: data['binShelfNo'],
                              // remarks: data['remarks'],
                              option: data['option'],
                              actionButton: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PickingDetailEdit(
                                  //       pickingData: data,
                                  //       onSuccess: fetchLatestData,
                                  //     ),
                                  //   ),
                                  // );
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
