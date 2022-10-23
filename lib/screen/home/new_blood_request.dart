import 'dart:math';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewBloodRequest extends StatefulWidget {
  const NewBloodRequest({Key? key}) : super(key: key);

  @override
  State<NewBloodRequest> createState() => _NewBloodRequestState();
}

class _NewBloodRequestState extends State<NewBloodRequest> {
  final _formKey = GlobalKey<FormState>();
  final bldRef = FirebaseFirestore.instance.collection('bloodRequests');
  // final userRef = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  //text field state
  String error = '';
  String pName = '';
  String cName = '';
  String location = '';
  String phoneNumber = '';
  String dropdownDistrict = 'Achham';
  String dropdownGender = 'Male';
  String dropdownGroup = 'A+';
  String bldAmt = '';
  String pCase = '';
  String? _hour, _minute;
  DateTime? pickedDat;

  bool? checkedValue = false;

  var group = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  // List of items in our dropdown menu
  var itemss = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  var items = [
    "Achham",
    "Arghakhanchi",
    "Baglung",
    "Baitadi",
    "Bajhang",
    "Bajura",
    "Banke",
    "Bara",
    "Bardiya",
    "Bhaktapur",
    "Bhojpur",
    "Chitwan",
    "Dadeldhura",
    "Dailekh",
    "Dang deukhuri",
    "Darchula",
    "Dhading",
    "Dhankuta",
    "Dhanusa",
    "Dholkha",
    "Dolpa",
    "Doti",
    "Gorkha",
    "Gulmi",
    "Humla",
    "Ilam",
    "Jajarkot",
    "Jhapa",
    "Jumla",
    "Kailali",
    "Kalikot",
    "Kanchanpur",
    "Kapilvastu",
    "Kaski",
    "Kathmandu",
    "Kavrepalanchok",
    "Khotang",
    "Lalitpur",
    "Lamjung",
    "Mahottari",
    "Makwanpur",
    "Manang",
    "Morang",
    "Mugu",
    "Mustang",
    "Myagdi",
    "Nawalparasi",
    "Nuwakot",
    "Okhaldhunga",
    "Palpa",
    "Panchthar",
    "Parbat",
    "Parsa",
    "Pyuthan",
    "Ramechhap",
    "Rasuwa",
    "Rautahat",
    "Rolpa",
    "Rukum",
    "Rupandehi",
    "Salyan",
    "Sankhuwasabha",
    "Saptari",
    "Sarlahi",
    "Sindhuli",
    "Sindhupalchok",
    "Siraha",
    "Solukhumbu",
    "Sunsari",
    "Surkhet",
    "Syangja",
    "Tanahu",
    "Taplejung",
    "Terhathum",
    "Udayapur",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 173, 45, 45),
        elevation: 0.0,
        title: const Text('Create new blood request'),
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
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient name',
                        labelText: 'Patient Name',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter patient name';
                      }
                      if (value.split(" ").length == 1) {
                        return 'Enter patient\'s full name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient\'s health issue',
                        labelText: 'Patient\'s illness',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter patient\'s health issue';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pCase = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Required Blood Amount",
                      hintText: 'Enter required blood amount',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter required blood amount';
                      }
                      // Check if the entered mobile number has the right format
                      if (value == '0') {
                        return 'Required blood amount can\'t be zero';
                      }
                      // Return null if the entered mobile number is valid
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        bldAmt = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: 'Enter your contact number',
                        labelText: 'Contact number',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your contact number';
                      }
                      // Check if the entered mobile number has the right format
                      if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      }
                      String pattern = r'(^9[7|8]\d{8}$)';
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
                        hintText: 'Enter your name',
                        labelText: 'Your Name',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your name';
                      }
                      if (value.split(" ").length == 1) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        cName = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient\'s location',
                        labelText: 'Location',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
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
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                        ), //icon of text field
                        labelText: "Enter Date" //label text of field
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
                        pickedDat = pickedDate;
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinput.text =
                              formattedDate; //set output date to TextField value.
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
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller:
                        timeinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        icon: Icon(
                          Icons.lock_clock,
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
                        if (min == 0) {
                          min = 00;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select the district    ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownDistrict,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownDistrict = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select required blood group         ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownGroup,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: group.map((String group) {
                          return DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownGroup = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 250,
                        child: ElevatedButton(
                          //color: Colors.red,
                          child: Text("create a request".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
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
                              bldRef.doc(generateRandomString()).set({
                                "id": uid,
                                "patientName": pName,
                                "location": location,
                                "case": pCase,
                                "phoneNumber": phoneNumber,
                                "bloodGroup": dropdownGroup,
                                'contactName': cName,
                                'requiredAmt': bldAmt,
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
