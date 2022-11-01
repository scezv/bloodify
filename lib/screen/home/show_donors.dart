import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ShowDonors extends StatefulWidget {
  //const ShowDonors({Key? key}) : super(key: key);

  String? bloodGrp, district;

  ShowDonors(this.district, this.bloodGrp);

  @override
  State<ShowDonors> createState() => _ShowDonorsState();
}

class _ShowDonorsState extends State<ShowDonors> {
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
            .collection('donor')
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
                            height: 10.0,
                          ),
                          Text(
                            '${doc['location']}, ${doc['district']}',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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
      // body: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Container(
      //     child: RichText(
      //       text: TextSpan(
      //           text: '',
      //           style: TextStyle(
      //               //decoration: TextDecoration.underline,
      //               //fontStyle: FontStyle.italic,
      //               //fontWeight: FontWeight.bold,
      //               color: Color.fromARGB(255, 170, 57, 48),
      //               fontSize: 32),
      //           children: <TextSpan>[
      //             TextSpan(
      //               text: bloodGroup,
      //               style: TextStyle(
      //                   //decoration: TextDecoration.underline,
      //                   //fontStyle: FontStyle.italic,
      //                   fontWeight: FontWeight.bold,
      //                   color: Color.fromARGB(255, 170, 57, 48),
      //                   fontSize: 32),
      //             ),
      //             TextSpan(
      //                 text: " Donors in ",
      //                 style: TextStyle(
      //                     //fontWeight: FontWeight.bold,
      //                     color: Colors.black,
      //                     fontSize: 30),
      //                 recognizer: TapGestureRecognizer()
      //                   ..onTap = () {
      //                     // navigate to desired screen
      //                   }),
      //             TextSpan(
      //                 text: selectedDistrict,
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.black,
      //                     fontSize: 32),
      //                 recognizer: TapGestureRecognizer()
      //                   ..onTap = () {
      //                     // navigate to desired screen
      //                   })
      //           ]),
      //     ),
      //     decoration: BoxDecoration(
      //       border: Border(
      //         bottom: BorderSide(color: Colors.black),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
