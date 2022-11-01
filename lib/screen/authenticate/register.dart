import 'package:bloodify/services/auth.dart';
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
  String dropdownDistrict = 'Achham';
  String dropdownGender = 'Male';
  String dropdownGroup = 'A+';

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
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: const Text('Register to Bloodify'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            },
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
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select your district    ',
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
                        'Select your gender    ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownGender,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: itemss.map((String itemss) {
                          return DropdownMenuItem(
                            value: itemss,
                            child: Text(itemss),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownGender = newValue!;
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
                        'Select your blood group         ',
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
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 250,
                        child: ElevatedButton(
                          //color: Colors.red,
                          child: Text("Register".toUpperCase(),
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
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password);
                              final User? cuser = auth.currentUser;
                              final uid = cuser?.uid;
                              if (checkedValue == true) {
                                userRef.doc(uid).set({
                                  'donor': true,
                                });
                              }
                              userRef.doc(uid).set({
                                "id": uid,
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
