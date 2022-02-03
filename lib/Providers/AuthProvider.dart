import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicked = false;
  String pickerError = '';
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String shopCity;
  String shopState;
  String placeName;
  String error = '';
  String email;

  //Upload vendor logo/image
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      notifyListeners();
      print('No image selected.');
    }
    return this.image;
  }

  // Future getCurrentAddress() async {
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   this.shopLatitude = _locationData.latitude;
  //   this.shopLongitude = _locationData.longitude;
  //   notifyListeners();

  //   final coordinates = new Coordinates(1.10, 45.50);
  //   var _addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var shopAddress = _addresses.first;
  //   this.shopAddress = shopAddress.addressLine;
  //   this.placeName = shopAddress.featureName;
  //   notifyListeners();
  //   return shopAddress;
  // }

  //Register Vendors

  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'Email already exists.';
        notifyListeners();
        print('The account already exists for that email');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //Login
  Future<UserCredential> loginVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //Save Vendors to DB
  Future<void> saveVendorDatatoDb({
    String url,
    String shopName,
    String phoneNumber,
    String shopAddress,
    String shopCity,
    String shopState,
    String description,
  }) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user.uid);
    _vendors.set({
      'uid': user.uid,
      'email': this.email,
      'shopName': shopName,
      'shopImage': url,
      'phoneNumber': phoneNumber,
      'shopAddress': shopAddress,
      'shopCity': shopCity,
      'shopState': shopState,
      'description': description,
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0.00,
      'isTopPicked': false,
      'accountVerified': false,
    });
    return null;
  }
}
