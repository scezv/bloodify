import 'package:bloodify/screen/home/edit_profile.dart';
import 'package:bloodify/screen/home/update_donor_status.dart';
import 'package:bloodify/screen/home/update_location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _editform = GlobalKey<FormState>();
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _PhoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
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
                  var email = data['email'];
                  var gender = data['gender'];
                  var location = data['location'];
                  var district = data['district'];
                  var bldGrp = data['bloodGroup'];

                  return SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Hello, \n" + name + ' ($bldGrp)',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(email,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(number,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('$location, $district',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditProfile()));
                                },
                                icon: Icon(
                                  // <-- Icon
                                  Icons.edit,
                                  size: 24.0,
                                ),
                                label: Text('  Edit Profile  '), // <-- Text
                              ),
                            ),
                            SizedBox(
                              height: 15,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => UpdateLocation()));
                                },
                                icon: Icon(
                                  // <-- Icon
                                  Icons.edit,
                                  size: 24.0,
                                ),
                                label: Text('  Update Location  '), // <-- Text
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.7,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateDonorStatus()));
                                },
                                icon: Icon(
                                  // <-- Icon
                                  Icons.edit,
                                  size: 24.0,
                                ),
                                label:
                                    Text('  Update Donor Status  '), // <-- Text
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Profile"),
  //       backgroundColor: Color.fromARGB(255, 170, 57, 48),
  //     ),
  //     body: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height / 30,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Hello, \n" + widget.name + ' (${widget.bldGrp})',
  //                   style: TextStyle(
  //                       fontSize: 30,
  //                       fontFamily: 'Roboto',
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Text(widget.email,
  //                     style: TextStyle(
  //                         fontSize: 20,
  //                         fontFamily: 'Roboto',
  //                         fontWeight: FontWeight.w500)),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Text('${widget.location}, ${widget.district}',
  //                     style: TextStyle(
  //                         fontSize: 20,
  //                         fontFamily: 'Roboto',
  //                         fontWeight: FontWeight.w500)),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 30,
  //               width: MediaQuery.of(context).size.width / 2.5,
  //               child: OutlinedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Color.fromARGB(255, 173, 45, 45),
  //                   elevation: 3,
  //                   onPrimary: Colors.white,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).push(
  //                       MaterialPageRoute(builder: (context) => EditProfile()));
  //                 },
  //                 icon: Icon(
  //                   // <-- Icon
  //                   Icons.edit,
  //                   size: 24.0,
  //                 ),
  //                 label: Text('  Edit Profile  '), // <-- Text
  //               ),
  //             ),
  //             SizedBox(
  //               height: 5,
  //             ),
  //             SizedBox(
  //               height: 30,
  //               width: MediaQuery.of(context).size.width / 1.99,
  //               child: OutlinedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Color.fromARGB(255, 173, 45, 45),
  //                   elevation: 3,
  //                   onPrimary: Colors.white,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => UpdateLocation()));
  //                 },
  //                 icon: Icon(
  //                   // <-- Icon
  //                   Icons.edit,
  //                   size: 24.0,
  //                 ),
  //                 label: Text('  Update Location  '), // <-- Text
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
