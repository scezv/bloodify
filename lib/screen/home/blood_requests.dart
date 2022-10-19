import 'package:bloodify/screen/home/new_blood_request.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({Key? key}) : super(key: key);

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blood Requests'),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewBloodRequest(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 173, 45, 45),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('bloodRequests')
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  String pName = doc['patientName'];
                  String bldGrp = doc['bloodGroup'];
                  return Card(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: 'Required Blood: ',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 170, 57, 48),
                                              fontSize: 18),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: bldGrp + '     ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                    fontSize: 18),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        // navigate to desired screen
                                                      })
                                          ]),
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      children: [
                                        Icon(Icons.location_on),
                                        RichText(
                                            text: TextSpan(
                                                text: doc['district'],
                                                style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.black,
                                                    fontSize: 18),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        // navigate to desired screen
                                                      })),
                                      ],
                                    )
                                    // Text(
                                    //   'Jhapa',
                                    //   textAlign: TextAlign.right,
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       color: Colors.black,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Patient Name:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['patientName'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // navigate to desired screen
                                              })),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Required Amount:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['requiredAmt'] +
                                                ' pint / pints',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // navigate to desired screen
                                              })),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Required Date:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['timestamp'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // navigate to desired screen
                                              })),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Patient\'s Condition:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['case'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // navigate to desired screen
                                              })),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Contact Info:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['contactName'] +
                                                ', ' +
                                                doc['phoneNumber'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // navigate to desired screen
                                              })),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    Center(
                                      child: new FlatButton(
                                          onPressed: () =>
                                              launch("tel://21213123123"),
                                          child: new Text("Call me")),
                                    ),
                                  ],
                                )
                                // Text('Name ' + pName),
                                // Text(
                                //   'Physics',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold, color: Colors.red),
                                // ),
                                // SizedBox(height: 5),
                                // Text('Total Chapters:10'),
                                // Text('Difficulty Level: Extremely Hard'),
                                // Text('Credit Hours: 4'),
                              ])));
                }).toList(),
              );
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              print('no data found');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // children: snapshot.data!.docs.map((doc) {
            //   return Card(
            //     child: ListTile(
            //       title: Text(doc['displayName']),
            //     ),
            //   );
            // }).toList(),
          }),
        ));
  }
}
