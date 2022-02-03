import 'dart:io';

import 'package:ahia_vendor/Providers/ProductProvider.dart';
import 'package:ahia_vendor/Services/FirebaseServices.dart';
import 'package:ahia_vendor/Widgets/CategoryList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditViewProduct extends StatefulWidget {
  final String productId;
  EditViewProduct({this.productId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot doc;
  final _formKey = GlobalKey<FormState>();
  List<File> images = [];
  final picker = ImagePicker();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added',
  ];
  String dropdownValue;

  var _brandText = TextEditingController();
  var _productNameText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _productDescriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _vatTextController = TextEditingController();
  var _shopName;

  double discount;
  String image;
  String productImage1;
  String productImage2;
  String productImage3;
  String productImage4;
  String productImage5;
  String productImage6;

  File _image;
  File _productImage1;
  File _productImage2;
  File _productImage3;
  File _productImage4;
  File _productImage5;
  File _productImage6;
  bool _visible = false;
  bool _editing = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _shopName = document.data()['seller']['shopName'];
          _brandText.text = document.data()['brand'];
          _productNameText.text = document.data()['productName'];
          _productDescriptionText.text = document.data()['productDescription'];
          _categoryTextController.text =
              document.data()['category']['mainCategory'];
          _subCategoryTextController.text =
              document.data()['category']['subCategory'];

          _priceText.text = document.data()['price'].toString();
          _comparedPriceText.text = document.data()['comparedPrice'].toString();
          var difference = (double.parse(_comparedPriceText.text) -
              double.parse(_priceText.text));
          discount = (difference / double.parse(_priceText.text)) * 100;
          image = document.data()['productImage'];
          productImage1 = document.data()['productImages1'];
          productImage2 = document.data()['productImages2'];
          productImage3 = document.data()['productImages3'];
          productImage4 = document.data()['productImages4'];
          productImage5 = document.data()['productImages5'];
          productImage6 = document.data()['productImages6'];

          dropdownValue = document.data()['collection'];
          _stockTextController.text =
              document.data()['stockQuantity'].toString();
          _lowStockTextController.text =
              document.data()['lowStockQuantity'].toString();
          _vatTextController.text = document.data()['tax'].toString();
        });
      }
    });
  }

  // select multiple images

  chooseImages() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      images.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        images.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

// display multiple images in gridview
  Widget buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return
            // index == 0
            //     ? Center(
            //         child: IconButton(
            //           icon: Icon(Icons.add),
            //           onPressed: () {
            //             chooseImages();
            //           },
            //         ),
            //       )
            //     :
            Container(
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(images[index]), fit: BoxFit.cover)),
        );
      },
    );
  }

// upload multiple images to cloud storage and retrieve download urls
  Future uploadProductImages(images, productName) async {
    firebase_storage.Reference ref;
    CollectionReference _productImages =
        FirebaseFirestore.instance.collection('productImages');
    for (var img in images) {
      ref = firebase_storage.FirebaseStorage.instance.ref().child(
          'ProductImages/${_shopName}/$productName/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _productImages.add({
            'productImages': value,
            'productId': widget.productId,
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    _editing = false;
                  });
                },
                child: Text('Edit', style: TextStyle(color: Colors.white)))
          ],
        ),
        bottomSheet: Container(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      color: Colors.black54,
                      child: Center(
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)))),
                ),
              ),
              Expanded(
                child: AbsorbPointer(
                  absorbing: _editing,
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        EasyLoading.show(status: 'Saving...');
                        if (_image != null) {
                          _provider
                              .uploadProductImage(
                                  _image.path, _productNameText.text)
                              .then((url) {
                            if (url != null) {
                              EasyLoading.dismiss();

                              if (_productImage1 != null) {
                                _provider.uploadProductImage1(
                                    _productImage1.path,
                                    _productNameText.text,
                                    widget.productId);
                              }
                              if (_productImage2 != null) {
                                _provider.uploadProductImage2(
                                    _productImage2.path,
                                    _productNameText.text,
                                    widget.productId);
                              }
                              if (_productImage3 != null) {
                                _provider.uploadProductImage3(
                                    _productImage3.path,
                                    _productNameText.text,
                                    widget.productId);
                              }
                              if (_productImage4 != null) {
                                _provider.uploadProductImage4(
                                    _productImage4.path,
                                    _productNameText.text,
                                    widget.productId);
                              }
                              if (_productImage5 != null) {
                                _provider.uploadProductImage5(
                                    _productImage5.path,
                                    _productNameText.text,
                                    widget.productId);
                              }
                              if (_productImage6 != null) {
                                _provider.uploadProductImage6(
                                    _productImage6.path,
                                    _productNameText.text,
                                    widget.productId);
                              }

                              _provider.updateProduct(
                                context: context,
                                productName: _productNameText.text,
                                productDescription:
                                    _productDescriptionText.text,
                                tax: double.parse(_vatTextController.text),
                                stockQuantity:
                                    int.parse(_stockTextController.text),
                                lowStockQuanity:
                                    int.parse(_lowStockTextController.text),
                                price: double.parse(_priceText.text),
                                comparedPrice:
                                    double.parse(_comparedPriceText.text),
                                brand: _brandText.text,
                                collection: dropdownValue,
                                category: _categoryTextController.text,
                                subCategory: _subCategoryTextController.text,
                                productId: widget.productId,
                                image: image,
                              );
                            }
                          });
                        } else {
                          if (_productImage1 != null) {
                            _provider.uploadProductImage1(_productImage1.path,
                                _productNameText.text, widget.productId);
                          }
                          if (_productImage2 != null) {
                            _provider.uploadProductImage2(_productImage2.path,
                                _productNameText.text, widget.productId);
                          }
                          if (_productImage3 != null) {
                            _provider.uploadProductImage3(_productImage3.path,
                                _productNameText.text, widget.productId);
                          }
                          if (_productImage4 != null) {
                            _provider.uploadProductImage4(_productImage4.path,
                                _productNameText.text, widget.productId);
                          }
                          if (_productImage5 != null) {
                            _provider.uploadProductImage5(_productImage5.path,
                                _productNameText.text, widget.productId);
                          }
                          if (_productImage6 != null) {
                            _provider.uploadProductImage6(_productImage6.path,
                                _productNameText.text, widget.productId);
                          }
                          _provider.updateProduct(
                            context: context,
                            productName: _productNameText.text,
                            productDescription: _productDescriptionText.text,
                            tax: double.parse(_vatTextController.text),
                            stockQuantity: int.parse(_stockTextController.text),
                            lowStockQuanity:
                                int.parse(_lowStockTextController.text),
                            price: double.parse(_priceText.text),
                            comparedPrice:
                                double.parse(_comparedPriceText.text),
                            brand: _brandText.text,
                            collection: dropdownValue,
                            category: _categoryTextController.text,
                            subCategory: _subCategoryTextController.text,
                            productId: widget.productId,
                            image: image,
                          );
                          EasyLoading.dismiss();
                        }
                        _provider.resetProvider();
                      }
                    },
                    child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(
                            child: Text('Save',
                                style: TextStyle(color: Colors.white)))),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: doc == null
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        AbsorbPointer(
                          absorbing: _editing,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _brandText,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      hintText: 'Brand',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                    ),
                                    controller: _productNameText,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          prefixText: '\NGN',
                                          prefixStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        controller: _priceText,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          prefixText: '\NGN',
                                          prefixStyle: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        controller: _comparedPriceText,
                                        style: TextStyle(
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.red,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8.0),
                                        child: Text(
                                            '${discount.toStringAsFixed(0)}% OFF',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                                Text('VAT inclusive',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                InkWell(
                                  onTap: () {
                                    _provider.getProductImage().then((image) {
                                      setState(() {
                                        _image = image;
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _image != null
                                        ? Image.file(_image, height: 300)
                                        : Image.network(image, height: 400),
                                  ),
                                ),
                                Text('About this product',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _productDescriptionText,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextFormField(
                                            controller: _categoryTextController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please select product category';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'not selected',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: _editing ? false : true,
                                        child: IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _categoryTextController.text =
                                                    _provider.selectedCategory;
                                                _visible = true;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sub-Category',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                              controller:
                                                  _subCategoryTextController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please select product sub-category';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Pls select Category first to avoid error',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(children: [
                                    Text(
                                      'Collection',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(width: 10),
                                    DropdownButton(
                                      hint: Text('Select Collection'),
                                      value: dropdownValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      onChanged: (String value) {
                                        setState(() {
                                          dropdownValue = value;
                                        });
                                      },
                                      items: _collections
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ]),
                                ),
                                Row(
                                  children: [
                                    Text('Stock : '),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _stockTextController,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Low Stock : '),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _lowStockTextController,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('VAT %: '),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _vatTextController,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),
                                // FlatButton(
                                //     color: Theme.of(context).primaryColor,
                                //     onPressed: chooseImages,
                                //     child: Text("Add more product images",
                                //         style: TextStyle(color: Colors.white))),
                                // buildGridView(),
                                // _image != null
                                // ? Image.file(_image, height: 300)
                                // : Image.network(image, height: 400),
                                Column(
                                  children: [
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage1 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage1 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage1 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage1)),
                                                      ),
                                                    )
                                                  : Image.network(productImage1,
                                                      height: 250),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage2 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage2 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage2 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage2)),
                                                      ),
                                                    )
                                                  : Image.network(productImage2,
                                                      height: 250),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage3 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage3 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage3 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage3)),
                                                      ),
                                                    )
                                                  : Image.network(productImage3,
                                                      height: 250),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage4 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage4 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage4 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage4)),
                                                      ),
                                                    )
                                                  : Image.network(productImage4,
                                                      height: 250),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage5 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage5 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage5 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage5)),
                                                      ),
                                                    )
                                                  : Image.network(productImage5,
                                                      height: 250),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _productImage6 = image;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: productImage6 == ''
                                                  ? SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: Card(
                                                        child: Center(
                                                            child: _productImage6 ==
                                                                    null
                                                                ? Text(
                                                                    'Select Image')
                                                                : Image.file(
                                                                    _productImage6)),
                                                      ),
                                                    )
                                                  : Image.network(productImage6,
                                                      height: 250),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),
                              ]),
                        )
                      ],
                    ))));
  }
}
