import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDonors extends StatefulWidget {
  //const ShowDonors({Key? key}) : super(key: key);

  String? bloodGrp, district;

  ShowDonors(this.district, this.bloodGrp);

  @override
  State<ShowDonors> createState() => _ShowDonorsState();
}

class _ShowDonorsState extends State<ShowDonors> {
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

  @override
  Widget build(BuildContext context) {
    String bloodGroup = widget.bloodGrp.toString();
    String selectedDistrict = widget.district.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 173, 45, 45),
        title: Text("$bloodGroup Donors, $selectedDistrict"),
      ),
      floatingActionButton: null,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('donor', isEqualTo: true)
            .where('available', isEqualTo: 'true')
            .where('district', isEqualTo: selectedDistrict)
            .where('bloodGroup', isEqualTo: bloodGroup)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              // children: snapshot.data!.docs.map((doc) {
              //   return Card(
              //     child: ListTile(
              //       title: Text(doc['displayName']),
              //     ),
              //   );
              // }).toList(),
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        // width: MediaQuery.of(context).size.width / 1.2,
                        // height: MediaQuery.of(context).size.height / 6,
                        children: [
                          Text(
                            doc['displayName'].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${doc['location']}, ${doc['district']}',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${doc['phoneNumber']}',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${doc['email']}',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Center(
                                      child: ElevatedButton.icon(
                                    onPressed: () => setState(() {
                                      _launched =
                                          _makePhoneCall(doc['phoneNumber']);
                                    }),
                                    icon: Icon(Icons.call),
                                    label: Text('Call   '),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 170, 57, 48),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 2),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Row(
                                children: [
                                  Center(
                                      child: ElevatedButton.icon(
                                    onPressed: () => setState(() {
                                      _launched = _makeSMS(doc['phoneNumber']);
                                    }),
                                    icon: Icon(Icons.message),
                                    label: Text('SMS   '),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 170, 57, 48),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 2),
                                    ),
                                  )),
                                ],
                              )
                            ],
                          )
                        ]),
                  ),
                );
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
        }),
      ),
    );
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
