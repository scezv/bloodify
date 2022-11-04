import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bloodify/screen/home/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     //'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

Future MailFeedback(message, emails) async {
  final service_id = 'service_s0im0ev';
  final template_id = 'template_t6oyl1s';
  final user_id = 'I7LBQiCxV2uGVs75_';
  //var emails = getE
  var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  try {
    var response = await http.post(url,
        headers: {
          'origin': '<http://localhost>',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': service_id,
          'template_id': template_id,
          'user_id': user_id,
          'template_params': {
            'message': message,
            'to_mail': emails,
          }
        }));
    print('[FEED BACK RESPONSE]');
    print(response.body);
  } catch (error) {
    print('[SEND FEEDBACK MAIL ERROR]');
  }
}

class NewBloodRequest extends StatefulWidget {
  const NewBloodRequest({Key? key}) : super(key: key);

  @override
  State<NewBloodRequest> createState() => _NewBloodRequestState();
}

class _NewBloodRequestState extends State<NewBloodRequest> {
  int _counter = 0;
  var emails;

  late TextEditingController _textToken;
  late TextEditingController _textSetToken;
  late TextEditingController _textTitle;
  late TextEditingController _textBody;

  @override
  void dispose() {
    _textToken.dispose();
    _textTitle.dispose();
    _textBody.dispose();
    _textSetToken.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getEmails();
  }

  late final FirebaseMessaging _messaging;
  final _formKey = GlobalKey<FormState>();
  final bldRef = FirebaseFirestore.instance.collection('bloodRequests');
  // final userRef = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  //text field state
  String error = '';
  String pName = '';
  String cName = '';
  String location = '';
  String phoneNumber = '';
  String dropdownDistrict = 'Achham';
  String dropdownGender = 'Male';
  String dropdownGroup = 'A+';
  String bldAmt = '';
  String pCase = '';
  String? _hour, _minute;
  DateTime? pickedDat;

  bool? checkedValue = false;

  var group = Global.group;

  // List of items in our dropdown menu
  var itemss = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  var items = Global.districts;
  getEmails() {
    final docRef =
        FirebaseFirestore.instance.collection("donorEmails").doc("emails");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data['emails']);
        emails = data['emails'];
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 173, 45, 45),
        elevation: 0.0,
        title: const Text('Create new blood request'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient name',
                        labelText: 'Patient Name',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter patient name';
                      }
                      if (value.split(" ").length == 1) {
                        return 'Enter patient\'s full name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient\'s health issue',
                        labelText: 'Patient\'s illness',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter patient\'s health issue';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        pCase = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      labelText: "Required Blood Amount",
                      hintText: 'Enter required blood amount',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter required blood amount';
                      }
                      // Check if the entered mobile number has the right format
                      if (value == '0') {
                        return 'Required blood amount can\'t be zero';
                      }
                      // Return null if the entered mobile number is valid
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        bldAmt = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        hintText: 'Enter your contact number',
                        labelText: 'Contact number',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your contact number';
                      }
                      // Check if the entered mobile number has the right format
                      if (value.length != 10) {
                        return 'Mobile Number must be of 10 digit';
                      }
                      String pattern = r'(^9[7|8]\d{8}$)';
                      RegExp regExp = new RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Mobile number not valid';
                      }
                      // Return null if the entered mobile number is valid
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        labelText: 'Your Name',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your name';
                      }
                      if (value.split(" ").length == 1) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        cName = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter patient\'s location',
                        labelText: 'Location',
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your location';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        location = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                        ), //icon of text field
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime
                              .now(), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        pickedDat = pickedDate;
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Date is required";
                      }
                      print(value);
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller:
                        timeinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        icon: Icon(
                          Icons.lock_clock,
                          color: Colors.red,
                        ), //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 08, minute: 00),
                      );
                      if (pickedTime != null) {
                        print(pickedTime);
                        String _hou = pickedTime.hour.toString();
                        int hour = int.parse(_hou);
                        _minute = pickedTime.minute.toString();
                        String _min = pickedTime.minute.toString();
                        int min = int.parse(_min);
                        String ampm = 'AM';
                        if (hour > 12) {
                          hour = hour - 12;
                          ampm = 'PM';
                        } else {
                          ampm = 'AM';
                        }
                        if (hour == 12) {
                          hour = 12;
                          ampm = 'PM';
                        }
                        if (hour == 0) {
                          hour = 12;
                          ampm = 'AM';
                        }
                        if (min == 0) {
                          min = 00;
                        }
                        String formattedTime = "$hour:$min $ampm";
                        print(formattedTime);
                        setState(() {
                          timeinput.text =
                              formattedTime; //set output date to TextField value.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Time is required";
                      }
                      print(value);
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select the district    ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownDistrict,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownDistrict = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select required blood group         ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownGroup,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: group.map((String group) {
                          return DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownGroup = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 250,
                        child: ElevatedButton(
                          //color: Colors.red,
                          child: Text("create a request".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            elevation: 3,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final User? cuser = auth.currentUser;
                              final uid = cuser?.uid;
                              bldRef.doc(generateRandomString()).set({
                                "id": uid,
                                "patientName": pName,
                                "location": location,
                                "case": pCase,
                                "phoneNumber": phoneNumber,
                                "bloodGroup": dropdownGroup,
                                'contactName': cName,
                                'requiredAmt': bldAmt,
                                'district': dropdownDistrict,
                                'datestamp': dateinput.text,
                                'timestamp': timeinput.text,
                                'date': DateTime.now(),
                              });
                              //print(dateinput);
                              //Navigator.pop(context);
                              // showSimpleNotification(
                              //     Text(
                              //         "this is a message from simple notification"),
                              //     background: Colors.green);
                              //print("the emails are: $emails");
                              String message =
                                  '$dropdownGroup required at $location on ${dateinput.text}, ${timeinput.text}';
                              MailFeedback(message, emails);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(15, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  // Future<bool> pushNotificationsAllUsers({
  //   required String title,
  //   required String body,
  // }) async {
  //   // FirebaseMessaging.instance.subscribeToTopic("myTopic1");

  //   String dataNotifications = '{ '
  //       ' "to" : "/topics/myTopic1" , '
  //       ' "notification" : {'
  //       ' "title":"$title" , '
  //       ' "body":"$body" '
  //       ' } '
  //       ' } ';

  //   var response = await http.post(
  //     Uri.parse(Constants.BASE_URL),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key= ${Constants.KEY_SERVER}',
  //     },
  //     body: dataNotifications,
  //   );
  //   print(response.body.toString());
  //   return true;
  // }

  // void showNotification() {
  //   // setState(() {
  //   //   _counter++;
  //   // });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing $_counter",
  //       "How you doin ?",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               channelDescription: channel.description,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@mipmap/ic_launcher')));
  // }
}
