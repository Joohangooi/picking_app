import 'package:flutter/material.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/data/sqlite_main_db_helper.dart';
import 'package:picking_app/screens/main/picking_detail.dart';
import 'package:picking_app/services/main_picking_service.dart';
import 'package:picking_app/services/picking_service.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/loading_overlay.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';

class LocalPickingMain extends StatefulWidget {
  final VoidCallback refreshCallback;
  const LocalPickingMain({super.key, required this.refreshCallback});
  @override
  _LocalPickingMainState createState() => _LocalPickingMainState();
}

class _LocalPickingMainState extends State<LocalPickingMain> {
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
    final pickingRecords = await SqliteMainDbHelper.getAllRecords();

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

  Future<void> handlePickingOnTap(String documentNo) async {
    try {
      setState(() {
        isLoading = true;
      });

      // check the existance of the data in the local database
      var pickingData = await SqliteDbHelper.getDataByDocumentNo(documentNo);

      // if yes, then navigate to the detail page
      if (pickingData.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PickingDetailPage(
                pickingData: pickingData,
                fetchPickingDataCallback: fetchPickingDataFromLocalDb),
          ),
        );
        return;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              item['binShelfNo'].toLowerCase().contains(query.toLowerCase()))
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
                            companyName: data['customerName'],
                            zone: data['zone'],
                            date: data['documentDate'],
                            option: data['option'],
                            actionButton: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this picking detail?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            var isDeleted =
                                                await SqliteMainDbHelper
                                                    .deleteRecord(
                                                        data['documentNo']);
                                            if (isDeleted) {
                                              final pickingDetail =
                                                  await MainPickingService()
                                                      .getPickingMainByDocumentNo(
                                                          data['documentNo']);
                                              pickingDetail['option'] = ' ';
                                              int update =
                                                  await PickingService()
                                                      .updatePickingDetail(
                                                          [pickingDetail]);
                                              if (update != 200) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Failed to update picking detail'),
                                                  ),
                                                );
                                              }
                                              await fetchPickingDataFromLocalDb();
                                              widget.refreshCallback();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Picking detail deleted successfully'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Failed to delete picking detail'),
                                                ),
                                              );
                                            }
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              handlePickingOnTap(data['documentNo']);
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
}
