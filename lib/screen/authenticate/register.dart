import 'package:bloodify/screen/home/globals.dart';
import 'package:bloodify/services/auth.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final donorRef = FirebaseFirestore.instance.collection('donor');
  final userRef = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth auth = FirebaseAuth.instance;

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String location = '';
  String phoneNumber = '';
  String dropdownDistrict = '';
  String dropdownGender = '';
  String dropdownGroup = '';

  bool? checkedValue = false;

  var group = Global.group;

  // List of items in our dropdown menu
  var itemss = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  var districts = Global.districts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 170, 57, 48),
        elevation: 0.0,
        title: const Text('Register to Bloodify'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
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
                        hintText: 'Enter your full name',
                        labelText: 'Full Name',
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
                        name = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter your email address',
                        labelText: 'Email',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Check if the entered email has the right format
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      // Return null if the entered email is valid
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
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
                        hintText: 'Enter your phone number',
                        labelText: 'Phone number',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your mobile number';
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
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters in length';
                      }
                      // Return null if the entered password is valid
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter your location',
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
                  SizedBox(height: 10.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Select your district    ',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     DropdownButton(
                  //       // Initial Value
                  //       value: dropdownDistrict,

                  //       // Down Arrow Icon
                  //       icon: const Icon(Icons.keyboard_arrow_down),

                  //       // Array list of items
                  //       items: items.map((String items) {
                  //         return DropdownMenuItem(
                  //           value: items,
                  //           child: Text(items),
                  //         );
                  //       }).toList(),
                  //       // After selecting the desired option,it will
                  //       // change button value to selected value
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           dropdownDistrict = newValue!;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
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
                  SizedBox(height: 10.0),
                  Center(
                    child: DropdownButtonFormField2(
                      buttonWidth: MediaQuery.of(context).size.width / 1.5,
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
                      isExpanded: true,
                      hint: const Text(
                        'Gender',
                        style: TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      offset: const Offset(50, 0),
                      dropdownWidth: MediaQuery.of(context).size.width / 1.6,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(15),
                          ),
                      items: itemss
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
                          return 'Please select the gender.';
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          dropdownGender = value.toString();
                        });
                        //Do something when changing the item if you want.
                      },
                      onSaved: (value) {
                        dropdownGender = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: DropdownButtonFormField2(
                      buttonWidth: MediaQuery.of(context).size.width / 1.5,
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
                      isExpanded: true,
                      hint: const Text(
                        'Blood Group',
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
                      items: group
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
                          return 'Please select the blood group.';
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          dropdownGroup = value.toString();
                        });
                        //Do something when changing the item if you want.
                      },
                      onSaved: (value) {
                        dropdownGroup = value.toString();
                      },
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Select your blood group         ',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     DropdownButton(
                  //       // Initial Value
                  //       value: dropdownGroup,

                  //       // Down Arrow Icon
                  //       icon: const Icon(Icons.keyboard_arrow_down),

                  //       // Array list of items
                  //       items: group.map((String group) {
                  //         return DropdownMenuItem(
                  //           value: group,
                  //           child: Text(group),
                  //         );
                  //       }).toList(),
                  //       // After selecting the desired option,it will
                  //       // change button value to selected value
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           dropdownGroup = newValue!;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 10,
                  //     ), //SizedBox
                  //     Text(
                  //       'Library Implementation Of Searching Algorithm: ',
                  //       style: TextStyle(fontSize: 17.0),
                  //     ), //Text
                  //     SizedBox(width: 10), //SizedBox
                  //     /** Checkbox Widget **/
                  //     Checkbox(
                  //       value: this.value,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           this.value = value;
                  //         });
                  //       },
                  //     ), //Checkbox
                  //   ], //<Widget>[]
                  // ),
                  CheckboxListTile(
                    title: Text("Sign up as a donor"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: ElevatedButton(
                          //color: Colors.red,
                          child: Text("Register".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 170, 57, 48),
                            elevation: 3,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              final User? cuser = auth.currentUser;
                              final uid = cuser?.uid;
                              if (checkedValue == true) {
                                final donorEmail = FirebaseFirestore.instance
                                    .collection("donorEmails")
                                    .doc("emails");
// Atomically add a new region to the "regions" array field.
                                donorEmail.update({
                                  "emails": FieldValue.arrayUnion([email]),
                                });
                              }
                              userRef.doc(uid).set({
                                "id": uid,
                                "donor": checkedValue,
                                "email": email,
                                "displayName": name,
                                "location": location,
                                "phoneNumber": phoneNumber,
                                "bloodGroup": dropdownGroup,
                                'gender': dropdownGender,
                                'district': dropdownDistrict,
                              });
                              if (result == null) {
                                setState(() {
                                  error = 'Please enter valid details';
                                });
                              }
                            }
                            // final bool?
                            // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            // isValid = _formKey.currentState?.validate();
                            // if (isValid == true) {
                            //   print(email);
                            //   print(password);
                            // }
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
}
