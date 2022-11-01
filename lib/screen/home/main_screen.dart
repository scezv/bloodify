import 'package:bloodify/screen/home/globals.dart';
import 'package:bloodify/screen/home/show_donors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  var districts = Global.districts;

  var bloodGroups = Global.group;

  String? selectedValueDistrict;
  String? selectedValueBloodGrp;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: Text('Bloodify'),
          backgroundColor: Color.fromARGB(255, 173, 45, 45),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
              },
              label: Text('Sign Out'),
            )
          ],
        ),
        //backgroundColor: C,
        //floatingActionButton: null,
        // body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //   stream: FirebaseFirestore.instance.collection('user')
        //   .where('donor', isEqualTo: true).snapshots(),
        //   builder: ((context, snapshot) {
        //     if (snapshot.hasData) {
        //       return ListView(
        //         // children: snapshot.data!.docs.map((doc) {
        //         //   return Card(
        //         //     child: ListTile(
        //         //       title: Text(doc['displayName']),
        //         //     ),
        //         //   );
        //         // }).toList(),
        //         children: snapshot.data!.docs.map((doc) {
        //           return Center(
        //             child: Container(
        //               width: MediaQuery.of(context).size.width / 1.2,
        //               height: MediaQuery.of(context).size.height / 6,
        //               child: Text('Name ' + doc['displayName']),
        //             ),
        //           );
        //         }).toList(),
        //       );
        //     }
        //     if (snapshot.hasError) {
        //       return const Text('Error');
        //     } else {
        //       print('no data found');
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     // children: snapshot.data!.docs.map((doc) {
        //     //   return Card(
        //     //     child: ListTile(
        //     //       title: Text(doc['displayName']),
        //     //     ),
        //     //   );
        //     // }).toList(),
        //     // children: snapshot.data!.docs.map((doc) {
        //     //   return Center(
        //     //     child: Container(
        //     //       width: MediaQuery.of(context).size.width / 1.2,
        //     //       height: MediaQuery.of(context).size.height / 6,
        //     //       child: Text('Name' + doc['id']),
        //     //     ),
        //     //   );
        //     // }).toList(),
        //     //);
        //   }),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(height: 20),
                      Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  const Text(
                                    'Blood Finder',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontFamily: 'Roboto',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Select the district',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  DropdownButtonFormField2(
                                    buttonWidth: 300,
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
                                    buttonPadding: const EdgeInsets.only(
                                        left: 20, right: 10),
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
                                  const SizedBox(height: 30),
                                  const Text(
                                    'Select the blood group',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  //const SizedBox(height: 30),
                                  DropdownButtonFormField2(
                                    buttonWidth: 300,
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
                                      'Blood group',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                    buttonHeight: 60,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    items: bloodGroups
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
                                        return 'Please select blood group.';
                                      }
                                    },
                                    onChanged: (value) {
                                      //Do something when changing the item if you want.
                                    },
                                    onSaved: (value) {
                                      selectedValueBloodGrp = value.toString();
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  // TextButton(
                                  //   onPressed: () {

                                  //   },
                                  //   child: const Text('Submit Button'),
                                  // ),
                                  OutlinedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 173, 45, 45),
                                      elevation: 3,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        print(
                                            '$selectedValueDistrict $selectedValueBloodGrp');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShowDonors(selectedValueDistrict, selectedValueBloodGrp),
                                          ),
                                        );
                                      } else {}
                                    },
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.search,
                                      size: 24.0,
                                    ),
                                    label: Text('  SEARCH  '), // <-- Text
                                  ),
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        ///],
                      ),
                      SizedBox(height: 15),
                      // Row(
                      //   children: [
                      //     TextButton(onPressed: null, child: Text('SGPA: 4')),
                      //     TextButton(
                      //         onPressed: null, child: Text('VIEW RESULT')),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
