import 'package:cloud_firestore/cloud_firestore.dart';

class Donor {
  String id;
  String displayName;
  String location;
  String district;
  String phoneNumber;
  String bloodGroup;
  String gender;

  Donor(
      {required this.id,
      required this.displayName,
      required this.location,
      required this.district,
      required this.bloodGroup,
      required this.phoneNumber,
      required this.gender});

  factory Donor.fromDocument(DocumentSnapshot doc) {
    return Donor(
      id: doc['id'],
      displayName: doc['displayName'],
      location: doc['location'],
      district: doc['district'],
      bloodGroup: doc['bloodGroup'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
    );
  }
}
