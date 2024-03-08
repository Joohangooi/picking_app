import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:picking_app/data/models/picking_model.dart';
import 'package:picking_app/widgets/app_bar_widget.dart';

class PickingDetailEdit extends StatefulWidget {
  final Map<String, dynamic> pickingData;

  const PickingDetailEdit({super.key, required this.pickingData});

  @override
  _PickingDetailEditState createState() => _PickingDetailEditState();
}

class _PickingDetailEditState extends State<PickingDetailEdit> {
  late TextEditingController _pickedQtyController;

  @override
  void initState() {
    super.initState();
    _pickedQtyController =
        TextEditingController(text: widget.pickingData['quantity'].toString());
  }

  @override
  void dispose() {
    _pickedQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PickingModel pickingModel = PickingModel.fromJson(widget.pickingData);

    Widget pickingInfo = Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.5), // Shadow color

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Document No:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  pickingModel.documentNo,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Code:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  pickingModel.stock,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Stock Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              pickingModel.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(
              color: Colors.grey[700],
            ),
            const SizedBox(height: 5.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    pickingModel.location,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bin/Shelf No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    pickingModel.binShelfNo,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Requested Quantity:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  pickingModel.requestQty.toString(),
                  style: const TextStyle(
                      fontSize: 18.0, decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity Picked:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  pickingModel.quantity.toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: (pickingModel.requestQty != pickingModel.quantity)
                          ? Colors.red
                          : Colors.green[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget quantityInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Requested Quantity:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              pickingModel.requestQty.toString(),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Picked Quantity:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              pickingModel.quantity.toString(),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: '${widget.pickingData['stock']}',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pickingInfo,
            const SizedBox(height: 16.0),
            TextField(
              controller: _pickedQtyController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Parse the input value to an integer
                int? newValue = int.tryParse(value);
                // Check if the parsed value is greater than the allowed quantity
                if (newValue != null && newValue > pickingModel.requestQty) {
                  // Show an error message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('New Value Exceeded Error'),
                        content: Text(
                            'Quantity cannot exceed ${pickingModel.requestQty}.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  // Reset the input field to the maximum allowed quantity
                  _pickedQtyController.text =
                      pickingModel.requestQty.toString();
                  // Move the cursor to the end of the text
                  _pickedQtyController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _pickedQtyController.text.length),
                  );
                }
              },
              decoration: const InputDecoration(
                labelText: 'Update Picked Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to update the picked quantity
                // and save the changes
                // final updatedPickingData = PickingModel(
                //   documentNo: widget.pickingData.documentNo,
                //   stock: widget.pickingData.stock,
                //   description: widget.pickingData.description,
                //   requestQty: widget.pickingData.requestQty,
                //   quantity: int.parse(_pickedQtyController.text),
                //   // Update other properties as needed
                // );

                // Here, you can call a function to update the data in the database
                // or perform any other necessary operations

                // Show a success message or navigate back to the previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Picked quantity updated successfully'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
