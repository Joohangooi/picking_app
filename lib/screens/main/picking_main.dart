import 'package:flutter/material.dart';
import 'package:picking_app/data/models/picking_main_model.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/data/sqlite_detail_db_helper.dart';
import 'package:picking_app/data/sqlite_main_db_helper.dart';
import 'package:picking_app/screens/auth/sign_in_page.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/services/picking_service.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/loading_overlay.dart';
import 'package:picking_app/widgets/local_picking_main.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';
import 'package:picking_app/services/main_picking_service.dart';
import 'package:picking_app/widgets/local_picking_detail.dart';

class PickingMainPage extends StatefulWidget {
  const PickingMainPage({super.key});

  @override
  _PickingMainPageState createState() => _PickingMainPageState();
}

class _PickingMainPageState extends State<PickingMainPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingData = [];
  List<Map<String, dynamic>> filteredPickingData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPickingData();
  }

  Future<void> fetchPickingData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await MainPickingService().getPickingMainByOption();
      setState(() {
        if ((result != 401) && (result != null)) {
          pickingData = List<Map<String, dynamic>>.from(result);
          filteredPickingData = List.from(pickingData);
        } else if (result == 401) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Unauthorized'),
                content: const Text(
                    'You are not authorized to access this resource.\nPlease login again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await jwt_service().deleteToken();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error fetching data!'),
            content: const Text(
                'Please contact the system administrator for assistance.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await jwt_service().deleteToken();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // Handle other errors
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handlePickingConfirmation(String documentNo) async {
    try {
      setState(() {
        isLoading = true;
      });
      // get data from database
      final pickingDetail =
          await MainPickingService().getPickingMainByDocumentNo(documentNo);

      // Handle the result from the API call
      if (pickingDetail is int && pickingDetail == 401) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Unauthorized'),
              content: const Text(
                  'You are not authorized to access this resource.\nPlease login again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await jwt_service().deleteToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Insert the data into the local database one by one
        final pickingModel = PickingMainModel.fromJson(pickingDetail);
        pickingModel.option = 'p';
        await SqliteMainDbHelper.insertData(pickingModel);
        // insert picking list
        await handlePickingDetail(documentNo);
        // update database
        pickingDetail['option'] = 't';
        var update =
            await PickingService().updatePickingDetail([pickingDetail]);
        if (update == 200) {
          fetchPickingData();
        }
        // pickingData = await SqliteMainDbHelper.getDataByDocumentNo(documentNo);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Picking confirmed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Handle API call error
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'An error occurred while fetching data. Please try again later.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handlePickingDetail(String documentNo) async {
    try {
      setState(() {
        isLoading = true;
      });
      final pickingDetail =
          await PickingService().getPickingDetailByDocumentNo(documentNo);

      // Handle the result from the API call
      if (pickingDetail is int && pickingDetail == 401) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Unauthorized'),
              content: const Text(
                  'You are not authorized to access this resource.\nPlease login again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await jwt_service().deleteToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        for (var item in pickingDetail) {
          // Insert the data into the local database one by one
          final pickingModel = PickingModel.fromJson(item);
          await SqliteDbHelper.insertData(pickingModel);
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPickingData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPickingData = List.from(pickingData);
      } else {
        filteredPickingData = pickingData
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
                item['documentDate']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                item['option'].toLowerCase().contains(query.toLowerCase()) ||
                item['issueBy']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                item['salesman']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget companyLogos = const Image(
      width: 100,
      height: 100,
      image:
          AssetImage('assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'),
    );

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Greenstem',
          actionButton: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              bool? confirmLogout = await showDialog<bool?>(
                context: context,
                barrierDismissible:
                    true, // Allow dismissing the dialog by tapping outside
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              // Check if the user confirmed, canceled, or dismissed the dialog
              if (confirmLogout == null) {
                // Dialog was dismissed by tapping outside, do nothing
              } else if (confirmLogout) {
                // Implement logout functionality here
                await jwt_service().deleteToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
          ),
        ),
        body: LoadingOverlay(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DefaultTabController(
              length: 3,
              initialIndex: 1,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'New'),
                      Tab(text: 'Picking'),
                      Tab(text: 'Details'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Main screen content
                        RefreshIndicator(
                          onRefresh: fetchPickingData,
                          displacement: 40.0,
                          edgeOffset: 20.0,
                          strokeWidth: 3.0,
                          triggerMode: RefreshIndicatorTriggerMode.onEdge,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              return false;
                            },
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: CustomCard(
                                            date: data['documentDate'],
                                            pickedNo: data['documentNo'],
                                            companyName: data['customerName'],
                                            option: data['option'],
                                            issueBy: data['issueBy'],
                                            salesMan: data['salesman'],
                                            remarks: data['remarks'],
                                            time: data['generateTime'],
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirm Picking'),
                                                    content: const Text(
                                                        'Do you want to pick this order?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('No'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await handlePickingConfirmation(
                                                              data[
                                                                  'documentNo']);
                                                        },
                                                        child:
                                                            const Text('Yes'),
                                                      ),
                                                    ],
                                                  );
                                                },
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: companyLogos,
                                ),
                              ],
                            ),
                          ),
                        ),
                        LocalPickingMain(refreshCallback: fetchPickingData),
                        LocalPickingDetail(refreshCallback: fetchPickingData),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
