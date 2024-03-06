import 'package:flutter/material.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';
import 'package:picking_app/widgets/card_widget.dart';
import 'package:picking_app/widgets/search_bar_widget.dart';
import 'package:picking_app/services/main_picking_service.dart'; // Import the service

class PickingDetailPage extends StatefulWidget {
  final String documentNo;
  const PickingDetailPage({required this.documentNo});

  @override
  _PickingDetailPageState createState() => _PickingDetailPageState();
}

class _PickingDetailPageState extends State<PickingDetailPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pickingData = [];

  @override
  void initState() {
    super.initState();
    // Call the API when the page loads
    fetchPickingDetailData();
  }

  Future<void> fetchPickingDetailData() async {
    try {
      final result = await MainPickingService()
          .getPickingDetailByDocumentNo(widget.documentNo);
      setState(() {
        if ((result != 401) && (result != null)) {
          pickingData = List<Map<String, dynamic>>.from(result);
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
      // print('Error fetching picking data: $e');
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
                  Navigator.pop(context);
                  // await jwt_service().deleteToken();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => WelcomeBackPage()),
                  // );
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
              itemCount: pickingData.length,
              itemBuilder: (context, index) {
                final data = pickingData[index];
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
