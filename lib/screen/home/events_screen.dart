import 'package:bloodify/screen/home/create_new_event.dart';
import 'package:bloodify/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void>? _launched;
  bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Events'),
          backgroundColor: Color.fromARGB(255, 173, 45, 45),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.logout),
              onPressed: () async {
                dynamic result = _auth.signOut();
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
                builder: (context) => CreateEventScreen(),
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
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  String eventDesc = doc['eventDesc'];
                  // String bldGrp = doc['bloodGroup'];
                  // String phoneNumberr = doc['phoneNumber'];
                  // _url = 'tel:$phoneNumber';
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
                                        text: doc['eventName'],
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 170, 57, 48),
                                            fontSize: 18),
                                      ),
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
                                                    fontWeight: FontWeight.bold,
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
                                // Row(
                                //   children: [
                                //     RichText(
                                //         text: const TextSpan(
                                //       text: 'Patient Name:    ',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.black,
                                //           fontSize: 16),
                                //     )),
                                //     RichText(
                                //         text: TextSpan(
                                //             text: doc['patientName'],
                                //             style: const TextStyle(
                                //                 color: Colors.black,
                                //                 fontSize: 16),
                                //             recognizer: TapGestureRecognizer()
                                //               ..onTap = () {
                                //                 // navigate to desired screen
                                //               })),
                                //   ],
                                // ),
                                const SizedBox(height: 5.0),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    RichText(
                                        text: const TextSpan(
                                      text: 'Event Location:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    RichText(
                                        text: TextSpan(
                                            text: doc['location'],
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
                                      text: 'Event Date:    ',
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
                                // Row(
                                //   children: [
                                //     RichText(
                                //         text: const TextSpan(
                                //       text: 'Patient\'s Condition:    ',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.black,
                                //           fontSize: 16),
                                //     )),
                                //     RichText(
                                //         text: TextSpan(
                                //             text: doc['case'],
                                //             style: const TextStyle(
                                //                 color: Colors.black,
                                //                 fontSize: 16),
                                //             recognizer: TapGestureRecognizer()
                                //               ..onTap = () {
                                //                 // navigate to desired screen
                                //               })),
                                //   ],
                                // ),
                                //const SizedBox(height: 5.0),
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
                                            text: doc['organizerName'] +
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
                                    Row(
                                      children: [
                                        Center(
                                            child: ElevatedButton.icon(
                                          onPressed: () => setState(() {
                                            _launched = _makePhoneCall(
                                                doc['phoneNumber']);
                                          }),
                                          icon: Icon(Icons.call),
                                          label: Text('Call   '),
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                255, 170, 57, 48),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 2),
                                          ),
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Center(
                                            child: ElevatedButton.icon(
                                          onPressed: () => setState(() {
                                            _launched =
                                                _makeSMS(doc['phoneNumber']);
                                          }),
                                          icon: Icon(Icons.message),
                                          label: Text('SMS   '),
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                255, 170, 57, 48),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 2),
                                          ),
                                        )),
                                      ],
                                    )
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
