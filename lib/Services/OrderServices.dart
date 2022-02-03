import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({'orderStatus': status});
    return result;
  }

  void launchCall(phoneNumber) async => await canLaunch(phoneNumber)
      ? await launch(phoneNumber)
      : throw 'Could not launch $phoneNumber';

  void launchEmail(email) async => await canLaunch(email)
      ? await launch(email)
      : throw 'Could not launch $email';
}
