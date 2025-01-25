import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuperUserPanelProvider with ChangeNotifier {
  Map<String, int> collectionsLengths = {};
  Map<String, int> usersCounts = {};
  Map<String, int> bookingsCounts = {};

  Future<void> fetchData() async {
    collectionsLengths = await getCollectionsLengths();
    usersCounts = await getUsersCounts();
    bookingsCounts = await getBookingsCountByHospital();
    notifyListeners();
  }

  Future<Map<String, int>> getCollectionsLengths() async {
    List<String> collectionNames = ['users', 'requests', 'hospitals', 'bookings'];
    Map<String, int> collectionsLengths = {};

    for (var collectionName in collectionNames) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();
      collectionsLengths[collectionName] = snapshot.docs.length;
    }
    return collectionsLengths;
  }

  Future<Map<String, int>> getUsersCounts() async {
    QuerySnapshot adminsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get();

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();

    return {
      'admins': adminsSnapshot.docs.length,
      'users': usersSnapshot.docs.length,
    };
  }

  Future<Map<String, int>> getBookingsCountByHospital() async {
    QuerySnapshot bookingsSnapshot =
        await FirebaseFirestore.instance.collection('bookings').get();

    Map<String, int> bookingsCountByHospital = {};

    for (var doc in bookingsSnapshot.docs) {
      String hospitalId = doc['hospitalId'];
      if (bookingsCountByHospital.containsKey(hospitalId)) {
        bookingsCountByHospital[hospitalId] =
            bookingsCountByHospital[hospitalId]! + 1;
      } else {
        bookingsCountByHospital[hospitalId] = 1;
      }
    }

    return bookingsCountByHospital;
  }
}
