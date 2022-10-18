import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({Key? key}) : super(key: key);

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is Privacy Policy Page"),
      ),
    );
  }
}