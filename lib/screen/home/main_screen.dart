import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("This is Main Page"),
        ),
        floatingActionButton: null,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('donor').snapshots(),
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
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 6,
                      child: Text('Name ' + doc['displayName']),
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
            // children: snapshot.data!.docs.map((doc) {
            //   return Card(
            //     child: ListTile(
            //       title: Text(doc['displayName']),
            //     ),
            //   );
            // }).toList(),
            // children: snapshot.data!.docs.map((doc) {
            //   return Center(
            //     child: Container(
            //       width: MediaQuery.of(context).size.width / 1.2,
            //       height: MediaQuery.of(context).size.height / 6,
            //       child: Text('Name' + doc['id']),
            //     ),
            //   );
            // }).toList(),
            //);
          }),
        ));
  }
}
