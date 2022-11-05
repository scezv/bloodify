import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateDonorStatus extends StatefulWidget {
  const UpdateDonorStatus({super.key});

  @override
  State<UpdateDonorStatus> createState() => _UpdateDonorStatusState();
}

class _UpdateDonorStatusState extends State<UpdateDonorStatus> {
  // Map<String, bool?> values = {
  //   'Yes': true,
  //   'No': false,
  // };
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String selected = "";
  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "I am available to donate.",
    },
    // {
    //   "id": 1,
    //   "value": false,
    //   "title": "No",
    // },
  ];
  bool? selectedValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Location"),
        backgroundColor: Color.fromARGB(255, 170, 57, 48),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 35.0),
        child: Column(
          children: [
            // Text(
            //   'Are you available to donate?',
            //   style: TextStyle(fontSize: 20),
            // ),

            Column(
              children: List.generate(
                checkListItems.length,
                (index) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    checkListItems[index]["title"],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  value: checkListItems[index]["value"],
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      for (var element in checkListItems) {
                        element["value"] = false;
                      }
                      checkListItems[index]["value"] = value;
                      selected =
                          "${checkListItems[index]["id"]}, ${checkListItems[index]["title"]}, ${checkListItems[index]["value"]}";
                      selectedValue = checkListItems[index]["value"];
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 173, 45, 45),
                  elevation: 3,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  print(selectedValue);
                  final User? cuser = auth.currentUser;
                  final uid = cuser?.uid;
                  Map<String, String> data = {
                    "available": selectedValue.toString(),
                  };
                  db.collection("user").doc(uid).update(data);
                  //db.collection("donor").doc(uid).update(data);
                  Navigator.pop(context);
                },
                icon: Icon(
                  // <-- Icon
                  Icons.save,
                  size: 24.0,
                ),
                label: Text('Update'), // <-- Text
              ),
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
