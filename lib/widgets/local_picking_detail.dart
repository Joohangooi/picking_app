import 'package:flutter/material.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/data/sqlite_main_db_helper.dart';
import 'package:picking_app/screens/main/picking_edit.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/loading_overlay.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';

class LocalPickingDetail extends StatefulWidget {
  final VoidCallback refreshCallback;
  const LocalPickingDetail({super.key, required this.refreshCallback});
  @override
  _LocalPickingState createState() => _LocalPickingState();
}

class _LocalPickingState extends State<LocalPickingDetail> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingDetailData = [];
  List<Map<String, dynamic>> filteredPickingData = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPickingDataFromLocalDb();
  }

  Future<void> fetchPickingDataFromLocalDb({String searchQuery = ''}) async {
    final pickingRecords = await SqliteDbHelper.getAllRecords();

    setState(() {
      pickingDetailData =
          pickingRecords.map((record) => record.toJson()).toList();

      if (searchQuery.isNotEmpty) {
        filterPickingData(searchQuery);
      } else {
        filteredPickingData = List.from(pickingDetailData);
      }
    });
  }

  void filterPickingData(String query) {
    setState(() {
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
              item['binShelfNo'].toLowerCase().contains(query.toLowerCase()) ||
              item['issueBy']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['salesman']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload All'),
          content: const Text(
              'Are you sure you want to upload all picking details?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
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
        body: LoadingOverlay(
      isLoading: isLoading,
      child: Stack(
        children: [
          Padding(
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
                            issueBy: data['issueBy'],
                            salesMan: data['salesMan'],
                            requestQty: data['requestQty'].toInt().toString(),
                            varianceQty: (data['requestQty'] - data['quantity'])
                                .toInt()
                                .toString(),
                            pickedQty: data['quantity'].toInt().toString(),
                            binNo: data['binShelfNo'],
                            option: data['option'],
                            actionButton: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PickingDetailEdit(
                                      pickingData: data,
                                      onSuccess: () async {
                                        fetchPickingDataFromLocalDb(
                                            searchQuery: searchController.text);

                                        // Fetch all records with the same documentNo
                                        final records = await SqliteDbHelper
                                            .getDataByDocumentNo(
                                                data['documentNo']);

                                        // Check if all options are 'c'
                                        final allOptionsAreC = records.every(
                                            (record) => record.option == 'c');

                                        if (allOptionsAreC) {
                                          // Update the option field in SqliteMainDbHelper
                                          await SqliteMainDbHelper.updateDetail(
                                              data['documentNo'], 'c');
                                        }
                                      },
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
                      ),
                    );
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
        ],
      ),
    ));
  }

  Future<void> checkAndUpdateOptions(String documentNo) async {
    bool allOptionsAreC = true;

    List<PickingModel> pickingData =
        await SqliteDbHelper.getDataByDocumentNo(documentNo);

    // Check if all options are 'c'
    for (final data in pickingData) {
      if (data.option != 'c') {
        allOptionsAreC = false;
        break;
      }
    }

    // If all options are 'c', update the option in SqliteMainDbHelper
    if (allOptionsAreC) {
      await SqliteMainDbHelper.updateDetail(documentNo, 'c');
    } else {
      await SqliteMainDbHelper.updateDetail(documentNo, 'p');
    }
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
          checkAndUpdateOptions(documentNo);
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
