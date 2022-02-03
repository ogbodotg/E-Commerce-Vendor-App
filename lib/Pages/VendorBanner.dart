import 'dart:io';

import 'package:ahia_vendor/Providers/ProductProvider.dart';
import 'package:ahia_vendor/Services/FirebaseServices.dart';
import 'package:ahia_vendor/Widgets/VendorBannerCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  static const String id = 'vendor-banner';

  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File _image;
  var _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
      VendorBannerCard(),
      Divider(
        thickness: 3,
      ),
      SizedBox(
        height: 20,
      ),
      Container(
          child: Center(
              child: Text('Add New Banner',
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.grey[200],
                  child: _image != null
                      ? Image.file(_image, fit: BoxFit.cover)
                      : Center(
                          child: Text('No Banner Image Selected'),
                        ),
                ),
              ),
              TextFormField(
                controller: _imagePathText,
                enabled: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: _visible ? false : true,
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _visible = true;
                          });
                        },
                        child: Text('Add New Banner',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _visible,
                child: Container(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              getBannerImage().then((value) {
                                if (_image != null) {
                                  setState(() {
                                    _imagePathText.text = _image.path;
                                  });
                                }
                              });
                            },
                            child: Text('Upload Banner Image',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _image != null ? false : true,
                            child: FlatButton(
                              onPressed: () {
                                EasyLoading.show(status: 'Saving banner...');
                                uploadBannerImage(
                                        _image.path, _provider.shopName)
                                    .then((url) {
                                  if (url != null) {
                                    _services.saveVendorBanner(url);
                                    setState(() {
                                      _imagePathText.clear();
                                      _image = null;
                                    });
                                    EasyLoading.dismiss();
                                    _provider.alertDialog(
                                      context: context,
                                      title: 'Banner Upload',
                                      content: 'Banner uploaded successfully',
                                    );
                                  } else {
                                    EasyLoading.dismiss();
                                    _provider.alertDialog(
                                      context: context,
                                      title: 'Banner Upload',
                                      content: 'Banner upload failed',
                                    );
                                  }
                                });
                              },
                              child: Text('Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              color: _image != null
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _visible = false;
                                _imagePathText.clear();
                                _image = null;
                              });
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    ]));
  }

  Future<File> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    return _image;
  }

  Future<String> uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('vendorBanner/$shopName/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('vendorBanner/$shopName/$timeStamp')
        .getDownloadURL();

    return downloadURL;
  }
}
