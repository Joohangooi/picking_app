import 'package:flutter/material.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/data/sqlite_main_db_helper.dart';
import 'package:picking_app/screens/main/picking_edit.dart';
import 'package:picking_app/services/picking_service.dart';
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
                            stockCode: data['stock'],
                            stockDesc: data['description'],
                            location: data['location'],
                            zone: data['zone'],
                            requestQty: data['requestQty'].toString(),
                            varianceQty: (data['requestQty'] - data['quantity'])
                                .toString(),
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
          // Positioned(
          //   bottom: 20.0,
          //   right: 20.0,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       // Show dialog
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             title: const Text('Sync Options'),
          //             actions: <Widget>[
          //               TextButton(
          //                 onPressed: () async {
          //                   try {
          //                     setState(() {
          //                       isLoading = true;
          //                     });
          //                     int statusCode = await PickingService()
          //                         .updatePickingDetail(pickingDetailData);
          //                     int isDeleted =
          //                         await SqliteDbHelper.deleteCompletedRecords();
          //                     if (statusCode == 200 && isDeleted > 0) {
          //                       ScaffoldMessenger.of(context).showSnackBar(
          //                         const SnackBar(
          //                           content: Text(
          //                               'Picking details updated successfully.'),
          //                         ),
          //                       );
          //                       fetchPickingDataFromLocalDb();
          //                       // Call the refresh callback
          //                       widget.refreshCallback();
          //                     } else {
          //                       ScaffoldMessenger.of(context).showSnackBar(
          //                         const SnackBar(
          //                           content: Text('No order to upload!'),
          //                         ),
          //                       );
          //                     }
          //                   } catch (e) {
          //                     // Exception: Error encountered
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       SnackBar(
          //                         content: Text('Error: $e'),
          //                       ),
          //                     );
          //                   } finally {
          //                     setState(() {
          //                       isLoading = false;
          //                     });
          //                   }

          //                   Navigator.of(context).pop();
          //                 },
          //                 child: const Text('Upload Only Completed Order'),
          //               ),
          //               TextButton(
          //                 onPressed: () async {
          //                   bool shouldUploadAll =
          //                       await showConfirmationDialog(context);
          //                   if (shouldUploadAll) {
          //                     try {
          //                       setState(() {
          //                         isLoading = true;
          //                       });

          //                       int statusCode = await PickingService()
          //                           .updatePickingDetail(pickingDetailData);
          //                       bool isDeleted = await SqliteDbHelper
          //                           .deleteAllPickingRecords();
          //                       if (statusCode == 200 && isDeleted) {
          //                         ScaffoldMessenger.of(context).showSnackBar(
          //                           const SnackBar(
          //                             content: Text(
          //                                 'Picking details updated successfully.'),
          //                           ),
          //                         );
          //                         fetchPickingDataFromLocalDb();
          //                         // Call the refresh callback
          //                         widget.refreshCallback();
          //                       } else {
          //                         ScaffoldMessenger.of(context).showSnackBar(
          //                           const SnackBar(
          //                             content: Text('Update Failed!'),
          //                           ),
          //                         );
          //                       }
          //                     } catch (e) {
          //                       // Exception: Error encountered
          //                       ScaffoldMessenger.of(context).showSnackBar(
          //                         SnackBar(
          //                           content: Text('Error: $e'),
          //                         ),
          //                       );
          //                     } finally {
          //                       setState(() {
          //                         isLoading = false;
          //                       });
          //                     }
          //                   }
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: const Text('Upload All'),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: const Text('Cancel'),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //     child: const Icon(Icons.sync),
          //   ),
          // ),
        ],
      ),
    ));
  }
}
