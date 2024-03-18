import 'package:flutter/material.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/data/sqlite_main_db_helper.dart';
import 'package:picking_app/screens/main/picking_edit.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/loading_overlay.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';
import 'package:picking_app/services/picking_service.dart';

class PickingDetailPage extends StatefulWidget {
  final List<PickingModel> pickingData;
  final VoidCallback fetchPickingDataCallback;

  const PickingDetailPage(
      {super.key,
      required this.pickingData,
      required this.fetchPickingDataCallback});

  @override
  _PickingDetailPageState createState() => _PickingDetailPageState();
}

class _PickingDetailPageState extends State<PickingDetailPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingDetailData = [];
  List<Map<String, dynamic>> filteredPickingData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pickingDetailData =
        widget.pickingData.map((record) => record.toJson()).toList();
    filteredPickingData = List.from(pickingDetailData);
  }

  @override
  void dispose() {
    super.dispose();
    checkAndUpdateOptions();
    widget.fetchPickingDataCallback();
  }

  void fetchLatestData() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Map<String, dynamic>> latestData =
          await SqliteDbHelper.getLatestData(
              widget.pickingData.first.documentNo);
      setState(() {
        pickingDetailData = latestData;
        filteredPickingData = List.from(pickingDetailData);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPickingData(String query) {
    setState(() {
      if (query.isEmpty) {
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

  Future<void> checkAndUpdateOptions() async {
    bool allOptionsAreC = true;

    // Check if all options are 'c'
    for (final data in filteredPickingData) {
      if (data['option'] != 'c') {
        allOptionsAreC = false;
        break;
      }
    }

    // If all options are 'c', update the option in SqliteMainDbHelper
    if (allOptionsAreC) {
      final documentNo = widget.pickingData.first.documentNo;
      await SqliteMainDbHelper.updateDetail(documentNo, 'c');
    } else {
      final documentNo = widget.pickingData.first.documentNo;
      await SqliteMainDbHelper.updateDetail(documentNo, 'p');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget companyLogos = const Image(
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
          onPressed: () async {
            try {
              setState(() {
                isLoading = true;
              });
              // Call the updatePickingDetail method and wait for the response
              int statusCode =
                  await PickingService().updatePickingDetail(pickingDetailData);

              // Handle the response
              if (statusCode == 200) {
                await SqliteMainDbHelper.deleteRecord(
                    widget.pickingData.first.documentNo);
                await SqliteDbHelper.deleteRecord(
                    widget.pickingData.first.documentNo);

                widget.fetchPickingDataCallback();

                // Success: Picking details updated successfully
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Picking details updated successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update Failed!'),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                ),
              );
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
        ),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
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
                          requestQty: data['requestQty'].toInt().toString(),
                          varianceQty: (data['requestQty'] - data['quantity'])
                              .toInt()
                              .toString(),
                          pickedQty: data['quantity'].toInt().toString(),
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
                          onLongPress: (requestQty) {
                            updateLocalDatabase(
                              data['documentNo'],
                              data['line'],
                              data['requestQty'],
                              data['quantity'],
                            );
                          },
                        ),
                      ),
                    ));
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: companyLogos,
            ),
          ],
        ),
      ),
    );
  }

  void updateLocalDatabase(
      String documentNo, int line, double requestQty, double quantity) async {
    try {
      bool success = await SqliteDbHelper.updateDetail(
        documentNo,
        line,
        requestQty,
        0.0,
      );

      if (success) {
        // Find the corresponding item in the pickingDetailData list
        final index = pickingDetailData.indexWhere(
            (item) => item['documentNo'] == documentNo && item['line'] == line);

        if (index != -1) {
          // Update the option and variance values
          pickingDetailData[index]['option'] = 'c';
          pickingDetailData[index]['quantity'] = requestQty;
          pickingDetailData[index]['variance'] = requestQty - quantity;

          // Update the filteredPickingData list
          filteredPickingData = List.from(pickingDetailData);

          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Picked quantity updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to find the item to update'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update picked quantity'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}
