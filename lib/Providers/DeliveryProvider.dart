import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DeliveryProvider with ChangeNotifier {
  String status;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
