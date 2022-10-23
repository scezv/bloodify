import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EventDetailsPage extends StatefulWidget {
  String district,
      eventName,
      eventDesc,
      location,
      organizerName,
      phoneNumber,
      datestamp,
      timestamp;

  EventDetailsPage(this.district, this.eventName, this.eventDesc, this.location,
      this.organizerName, this.phoneNumber, this.datestamp, this.timestamp);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.eventName),
        backgroundColor: Color.fromARGB(255, 173, 45, 45),
        elevation: 0.0,
      ),
      body: Column(children: [
        const SizedBox(
          height: 20.0,
        ),
        Image.asset(
          'assets/img/blood.png',
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              child: Text(
            widget.eventName + " is " + widget.eventDesc,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                //color: Color.fromARGB(255, 170, 57, 48),
                fontSize: 20),
          )),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                'Venue:',
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 170, 57, 48),
                    fontSize: 20),
              )),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_month,
                color: Color.fromARGB(255, 170, 57, 48),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                widget.datestamp + ' on ' + widget.timestamp,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    //color: Color.fromARGB(255, 170, 57, 48),
                    fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color.fromARGB(255, 170, 57, 48),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                widget.location + ", " + widget.district,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    //color: Color.fromARGB(255, 170, 57, 48),
                    fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.call,
                color: Color.fromARGB(255, 170, 57, 48),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    //color: Color.fromARGB(255, 170, 57, 48),
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
