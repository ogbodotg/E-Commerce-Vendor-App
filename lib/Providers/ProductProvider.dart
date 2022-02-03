import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String shopName;
  String productImageUrl;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  resetProvider() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.image = null;
    this.productImageUrl = null;
    notifyListeners();
  }

// upload multiple images to cloud storage and get dowload urls
  Future uploadProductImages(images, productName, productId) async {
    firebase_storage.Reference ref;
    CollectionReference _productImages =
        FirebaseFirestore.instance.collection('productImages');
    for (var img in images) {
      ref = firebase_storage.FirebaseStorage.instance.ref().child(
          'ProductImages/${this.shopName}/$productName/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _productImages.add({
            'productImages': value,
            'productId': productId,
          });
        });
      });
    }
  }

  Future<String> uploadProductImage1(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages1': value,
        });
      });
    });
  }

  Future<String> uploadProductImage2(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages2': value,
        });
      });
    });
  }

  Future<String> uploadProductImage3(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages3': value,
        });
      });
    });
  }

  Future<String> uploadProductImage4(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages4': value,
        });
      });
    });
  }

  Future<String> uploadProductImage5(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages5': value,
        });
      });
    });
  }

  Future<String> uploadProductImage6(filePath, productName, productId) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    firebase_storage.Reference ref;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProductImages/${this.shopName}/$productName/$timeStamp');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        _products.doc(productId).update({
          'productImages6': value,
        });
      });
    });
  }

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productImageUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProductImage() async {
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

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Future<void> saveProductToDb({
    productName,
    productDescription,
    price,
    comparedPrice,
    collection,
    brand,
    categoryName,
    tax,
    stockQuantity,
    lowStockQuanity,
    productId,
    context,
  }) {
    // var timeStamp = DateTime.now().millisecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user.uid},
        'productName': productName,
        'productDescription': productDescription,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage,
        },
        'tax': tax,
        'stockQuantity': stockQuantity,
        'lowStockQuantity': lowStockQuanity,
        'published': false,
        'productId': productId,
        'productImage': this.productImageUrl,
        'productImages1': '',
        'productImages2': '',
        'productImages3': '',
        'productImages4': '',
        'productImages5': '',
        'productImages6': '',
      });
      this.alertDialog(
        context: context,
        title: 'Save Product',
        content: 'Product details saved successfully',
      );
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Product', content: '${e.toString()}');
    }
    return null;
  }

  Future<void> updateProduct({
    productName,
    productDescription,
    price,
    comparedPrice,
    collection,
    brand,
    categoryName,
    tax,
    stockQuantity,
    lowStockQuanity,
    context,
    productId,
    image,
    category,
    subCategory,
  }) {
    // var timeStamp = DateTime.now().millisecondsSinceEpoch;
    // User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        'productName': productName,
        'productDescription': productDescription,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
        },
        'tax': tax,
        'stockQuantity': stockQuantity,
        'lowStockQuantity': lowStockQuanity,
        'productId': productId,
        'productImage':
            this.productImageUrl == null ? image : this.productImageUrl,
        'productImages1': '',
        'productImages2': '',
        'productImages3': '',
        'productImages4': '',
        'productImages5': '',
        'productImages6': '',
      });
      this.alertDialog(
        context: context,
        title: 'Save Product',
        content: 'Product details saved successfully',
      );
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Product', content: '${e.toString()}');
    }
    return null;
  }
}
