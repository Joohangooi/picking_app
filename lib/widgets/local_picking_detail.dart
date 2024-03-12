import 'package:flutter/material.dart';

class LocalPickingDetail extends StatefulWidget {
  const LocalPickingDetail({Key? key}) : super(key: key);

  @override
  _LocalPickingState createState() => _LocalPickingState();
}

class _LocalPickingState extends State<LocalPickingDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab Screen'),
      ),
      body: const Center(
        child: Text('This is the Tab Screen'),
      ),
    );
  }
}
