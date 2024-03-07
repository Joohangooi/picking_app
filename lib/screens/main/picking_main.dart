import 'package:flutter/material.dart';
import 'package:picking_app/data/sqlite_db_helper.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';
import 'package:picking_app/screens/main/picking_detail.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/services/picking_service.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';
import 'package:picking_app/services/main_picking_service.dart';

class PickingMainPage extends StatefulWidget {
  @override
  _PickingMainPageState createState() => _PickingMainPageState();
}

class _PickingMainPageState extends State<PickingMainPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingData = [];
  List<Map<String, dynamic>> filteredPickingData = [];

  @override
  void initState() {
    super.initState();
    fetchPickingData();
  }

  Future<void> fetchPickingData() async {
    try {
      final result = await MainPickingService().getMainPickingData();
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
                        MaterialPageRoute(
                            builder: (context) => WelcomeBackPage()),
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
                    MaterialPageRoute(builder: (context) => WelcomeBackPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // Handle other errors
    }
  }

  Future<void> handlePickingConfirmation(String documentNo) async {
    try {
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
                      MaterialPageRoute(
                          builder: (context) => WelcomeBackPage()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        if (pickingDetail is List<dynamic>) {
          for (var item in pickingDetail) {
            final pickingModel = PickingModel.fromJson(item);
            await SqliteDbHelper().insertPicking(pickingModel);
          }
        } else {
          final pickingModel = PickingModel.fromJson(pickingDetail);
          await SqliteDbHelper().insertPicking(pickingModel);
        }
        Navigator.of(context).pop(); // Dismiss the dialog box
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PickingDetailPage(),
          ),
        );
      }
    } catch (e) {
      // Handle API call error
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          print(e);
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
    }
  }

  void filterPickingData(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all picking data
        filteredPickingData = List.from(pickingData);
      } else {
        // Otherwise, filter the picking data based on the query
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
                    .contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget company_logos = const Image(
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
            // Implement logout functionality here
            await jwt_service().deleteToken();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeBackPage()),
            );
          },
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
                        date: data['documentDate'],
                        pickedNo: data['documentNo'],
                        companyName: data['customerName'],
                        zone: data['zone'],
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Picking'),
                                content: const Text(
                                    'Do you want to pick this order?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await handlePickingConfirmation(
                                          data['documentNo']);
                                    },
                                    child: const Text('Yes'),
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: company_logos,
            ),
          ],
        ),
      ),
    );
  }
}
