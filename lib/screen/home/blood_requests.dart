import 'package:bloodify/screen/home/home.dart';
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

//String _url = 'tel:1234567890';

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final Home home = new Home();

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

  bool _isButtonDisabled(var id) {
    if (auth.currentUser!.uid != id) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteDoc(var id) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 170, 57, 48),
          centerTitle: false,
          title: Text("Blood Requests"),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color: Colors.black,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: Text("Profile")),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text("Logout")
                        ],
                      )),
                ],
                onSelected: (item) => home.SelectedItem(context, item),
              ),
            ),
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
              .orderBy("date", descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  String pName = doc['patientName'];
                  String bldGrp = doc['bloodGroup'];
                  //print("${doc['time'].toDate()}");
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
                                      text: 'Required Location:    ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                    )),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: RichText(
                                          text: TextSpan(
                                              text: doc['location'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  // navigate to desired screen
                                                })),
                                    ),
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
                                            text:
                                                "${doc['datestamp']} on ${doc['timestamp']}",
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
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Center(
                                            child: ElevatedButton.icon(
                                          onPressed:
                                              _isButtonDisabled(doc['id'])
                                                  ? null
                                                  : (() {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'bloodRequests')
                                                          .doc(doc.id)
                                                          .delete()
                                                          .then((value) {
                                                        print('Deleted');
                                                        //Navigator.pop(context,'Deleted');
                                                      });
                                                      ;
                                                    }),
                                          icon: Icon(Icons.message),
                                          label: Text('Mark Fulfilled '),
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
