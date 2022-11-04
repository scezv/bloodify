import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _editform = GlobalKey<FormState>();
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _PhoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          backgroundColor: Color.fromARGB(255, 170, 57, 48),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _editform,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .doc(auth.currentUser!.uid)
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data!.data();
                  var name = data!['displayName'];
                  var number = data['phoneNumber'];

                  _UserNameController = TextEditingController(text: name);
                  _PhoneNoController = TextEditingController(text: number);

                  return Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: Column(
                        children: [
                          Center(
                              child: Image.asset(
                            'assets/img/logo.png',
                            width: 200.0,
                          )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 50),
                            child: TextFormField(
                              // initialValue: name,
                              controller: _UserNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field cant be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  label: const Text('Your Name'),
                                  hintText: 'Your Name',
                                  hintStyle:
                                      const TextStyle(fontFamily: 'OpenSans'),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.red),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: TextFormField(
                              controller: _PhoneNoController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // initialValue: number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  label: const Text("Phone Number"),
                                  hintText: 'Phone Number',
                                  hintStyle:
                                      const TextStyle(fontFamily: 'OpenSans'),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.red),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                // Check if the entered mobile number has the right format
                                if (value.length != 10) {
                                  return 'Mobile Number must be of 10 digit';
                                }
                                String pattern = r'(^9[7|8]\d{8}$)';
                                RegExp regExp = RegExp(pattern);
                                if (!regExp.hasMatch(value)) {
                                  return 'Mobile number not valid';
                                }
                                // Return null if the entered mobile number is valid
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // print('************************');
                              // print(cvUrl);
                              // print(pfpUrl);
                              FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(auth.currentUser!.uid)
                                  .update({
                                'displayName': _UserNameController.text,
                                'phoneNumber': _PhoneNoController.text,
                                'email': auth.currentUser!.email,
                              }).then((value) {
                                Navigator.pop(context);
                              }).onError((error, stackTrace) async {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(error.toString()),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 170, 57, 48),
                              ),
                              child: const Center(
                                  child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          //);
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}
