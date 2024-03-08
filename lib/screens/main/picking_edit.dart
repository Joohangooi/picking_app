import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Edit Picking Detail',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document No: ${widget.pickingData['documentNo']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Stock Code: ${widget.pickingData['stock']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Stock Description: ${widget.pickingData['description']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Request Quantity: ${widget.pickingData['requestQty']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _pickedQtyController,
              decoration: const InputDecoration(
                labelText: 'Picked Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
