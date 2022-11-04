import 'package:bloodify/screen/home/blood_requests.dart';
import 'package:bloodify/screen/home/main_screen.dart';
import 'package:bloodify/screen/home/privacy_policy.dart';
import 'package:bloodify/screen/home/events_screen.dart';
import 'package:bloodify/screen/home/profile.dart';
import 'package:bloodify/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      // appBar: AppBar(
      //   title: Text('Bloodify'),
      //   backgroundColor: Color.fromARGB(255, 173, 45, 45),
      //   elevation: 0.0,
      //   actions: <Widget>[
      //     FlatButton.icon(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         await _auth.signOut();
      //       },
      //       label: Text('Sign Out'),
      //     )
      //   ],
      // ),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 170, 57, 48),
      //   centerTitle: false,
      //   title: Text("Bloodify"),
      //   actions: [
      //     Theme(
      //       data: Theme.of(context).copyWith(
      //           textTheme: TextTheme().apply(bodyColor: Colors.black),
      //           dividerColor: Colors.white,
      //           iconTheme: IconThemeData(color: Colors.white)),
      //       child: PopupMenuButton<int>(
      //         color: Colors.black,
      //         itemBuilder: (context) => [
      //           PopupMenuItem<int>(value: 0, child: Text("Settings")),
      //           PopupMenuItem<int>(value: 1, child: Text("Privacy Policy    ")),
      //           PopupMenuDivider(),
      //           PopupMenuItem<int>(
      //               value: 2,
      //               child: Row(
      //                 children: [
      //                   Icon(
      //                     Icons.logout,
      //                     color: Colors.red,
      //                   ),
      //                   const SizedBox(
      //                     width: 7,
      //                   ),
      //                   Text("Logout")
      //                 ],
      //               )),
      //         ],
      //         onSelected: (item) => SelectedItem(context, item),
      //       ),
      //     ),
      //   ],
      // ),
      body: DefaultTabController(
          length: 3,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
              ),
              const Scaffold(
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.search_sharp),
                      ),
                      Tab(
                        icon: Icon(Icons.bloodtype),
                      ),
                      Tab(
                        icon: Icon(Icons.event),
                      ),
                    ],
                    labelColor: Color.fromARGB(255, 170, 57, 48),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 170, 57, 48), width: 4.0),
                      insets: EdgeInsets.only(bottom: 44),
                    ),
                    unselectedLabelColor: Colors.grey,
                  ),
                ),
                body: TabBarView(children: [
                  MainScreen(),
                  BloodRequestScreen(),
                  EventsScreen(),
                ]),
              )
            ],
          )),
    );
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 1:
        print("User Logged out");
        _auth.signOut();
        break;
    }
  }
}
