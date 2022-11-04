import 'dart:math';

import 'package:bloodify/screen/home/globals.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final evtRef = FirebaseFirestore.instance.collection('events');
  // final userRef = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  //text field state
  String error = '';
  String eventName = '';
  String oName = '';
  String location = '';
  String phoneNumber = '';
  String dropdownDistrict = 'Achham';
  // String dropdownGender = 'Male';
  // String dropdownGroup = 'A+';
  String bldAmt = '';
  String desc = '';

  var districts = Global.districts;

  String? _hour, _minute, _time;
  String? dateTime;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 173, 45, 45),
        elevation: 0.0,
        title: const Text('Events'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Create Event',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 173, 45, 45),
                        fontSize: 32),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Event\'s name',
                        labelText: 'Event\'s Name',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Event\'s Name can\'t be empty';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        eventName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Event Description',
                        labelText: 'Event Description',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Event Description can\'t be empty';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        desc = val;
                      });
                    },
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: 'Contact Number',
                        labelText: 'Contact Number',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your contact number';
                      }
                      // Check if the entered mobile number has the right format
                      if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      }
                      String pattern = r'(^9[6|7|8]\d{8}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Mobile number not valid';
                      }
                      // Return null if the entered mobile number is valid
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Organized by',
                        labelText: 'Organizer',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter organizer\'s name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        oName = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Event\'s location',
                        labelText: 'Location',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter event\'s location';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        location = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.red,
                      ), //icon of text field
                      labelText: "Enter Date", //label text of field
                      //errorText: _validateDate ? 'Value Can\'t Be Empty' : null,
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime
                              .now(), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinput.text = formattedDate;
                          //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Date is required";
                      }
                      print(value);
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller:
                        timeinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        suffixIcon: Icon(
                          Icons.timer,
                          color: Colors.red,
                        ), //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 08, minute: 00),
                      );
                      if (pickedTime != null) {
                        print(pickedTime);
                        String _hou = pickedTime.hour.toString();
                        int hour = int.parse(_hou);
                        _minute = pickedTime.minute.toString();
                        String _min = pickedTime.minute.toString();
                        int min = int.parse(_min);
                        String ampm = 'AM';
                        if (hour > 12) {
                          hour = hour - 12;
                          ampm = 'PM';
                        } else {
                          ampm = 'AM';
                        }
                        if (hour == 12) {
                          hour = 12;
                          ampm = 'PM';
                        }
                        if (hour == 0) {
                          hour = 12;
                          ampm = 'AM';
                        }
                        String formattedTime = "$hour:$min $ampm";
                        print(formattedTime);
                        setState(() {
                          timeinput.text =
                              formattedTime; //set output date to TextField value.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Time is required";
                      }
                      print(value);
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: DropdownButtonFormField2(
                      //buttonWidth: ,
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        //isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                            //borderRadius: BorderRadius.circular(15),
                            ),
                        //Add more decoration as you want here
                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      ),
                      isExpanded: false,
                      hint: const Text(
                        'District',
                        style: TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      dropdownWidth: MediaQuery.of(context).size.width / 1.6,
                      offset: const Offset(50, 0),
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
                                    fontSize: 16,
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
                        setState(() {
                          dropdownDistrict = value.toString();
                        });
                        //Do something when changing the item if you want.
                      },
                      onSaved: (value) {
                        dropdownDistrict = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: ElevatedButton(
                          //color: Colors.red,
                          child: Text("create a event".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 173, 45, 45),
                            elevation: 3,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              //dynamic result;
                              //  =
                              //     await _auth.registerWithEmailAndPassword(
                              //         email, password);
                              final User? cuser = auth.currentUser;
                              final uid = cuser?.uid;
                              // if (checkedValue == true) {
                              //   donorRef.doc(uid).set({
                              //     "id": uid,
                              //     "displayName": name,
                              //     "location": location,
                              //     "phoneNumber": phoneNumber,
                              //     "bloodGroup": dropdownGroup,
                              //     'gender': dropdownGender,
                              //     'district': dropdownDistrict,
                              //   });
                              // }
                              evtRef.doc(generateRandomString()).set({
                                "id": uid,
                                "eventName": eventName,
                                "eventDesc": desc,
                                "location": location,
                                "phoneNumber": phoneNumber,
                                'organizerName': oName,
                                'district': dropdownDistrict,
                                'datestamp': dateinput.text,
                                'timestamp': timeinput.text,
                                'date': DateTime.now(),
                              });
                              print(dateinput);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(15, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
