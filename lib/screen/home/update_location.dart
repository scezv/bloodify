import 'dart:ffi';

import 'package:bloodify/screen/home/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UpdateLocation extends StatefulWidget {
  const UpdateLocation({super.key});

  @override
  State<UpdateLocation> createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String selectedValueDistrict = '';
  final _formKey = GlobalKey<FormState>();
  var districts = Global.districts;
  String location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Location"),
        backgroundColor: Color.fromARGB(255, 170, 57, 48),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Update Location',
                  style: TextStyle(
                      color: Color.fromARGB(255, 170, 57, 48),
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your location',
                      labelText: 'Location',
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your location';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      location = val;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: DropdownButtonFormField2(
                    buttonWidth: MediaQuery.of(context).size.width / 1.5,
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      //isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'District',
                      style: TextStyle(fontSize: 14),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    dropdownWidth: 200,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: districts
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select the district.';
                      }
                    },
                    onChanged: (value) {
                      //Do something when changing the item if you want.
                    },
                    onSaved: (value) {
                      selectedValueDistrict = value.toString();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.6,
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        //print('$selectedValueDistrict');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ShowDonors(
                        //         selectedValueDistrict, selectedValueBloodGrp),
                        //   ),
                        // );
                        final User? cuser = auth.currentUser;
                        final uid = cuser?.uid;
                        Map<String, String> data = {
                          "location": location,
                          "district": selectedValueDistrict
                        };
                        db.collection("user").doc(uid).update(data);
                        db.collection("donor").doc(uid).update(data);
                        Navigator.pop(context);
                      } else {}
                    },
                    icon: Icon(
                      // <-- Icon
                      Icons.save,
                      size: 24.0,
                    ),
                    label: Text('  Update  '), // <-- Text
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
