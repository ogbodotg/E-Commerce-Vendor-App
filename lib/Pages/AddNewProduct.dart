import 'dart:io';
import 'package:ahia_vendor/Providers/ProductProvider.dart';
import 'package:ahia_vendor/Widgets/CategoryList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class AddNewProduct extends StatefulWidget {
  static const String id = 'addnew-product';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  // CollectionReference imgRef;

  firebase_storage.Reference ref;

  final _formKey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added',
  ];
  String dropdownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockQtyTextController = TextEditingController();
  var _stockQtyTextController = TextEditingController();
  var timeStamp = DateTime.now().millisecondsSinceEpoch;

  File _image;
  File _productImage1;
  File _productImage2;
  File _productImage3;
  File _productImage4;
  File _productImage5;
  File _productImage6;

  bool _visible = false;
  bool _track = false;
  String productName;
  String productDescription;
  double price;
  double comparePrice;
  double tax;
  int stockQuantity;
  String productId;

// list to store multiple images
  List<File> images = [];
  final picker = ImagePicker();

  @override
  void initState() {
    setState(() {
      productId = timeStamp.toString();
    });
    // imgRef = FirebaseFirestore.instance.collection(collectionPath)
    super.initState();
  }

// function to select multiple images
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

// gridview to display picked multiple images
  Widget buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(images[index]), fit: BoxFit.cover)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_image != null) {
                              EasyLoading.show(status: 'Saving...');
                              _provider
                                  .uploadProductImage(_image.path, productName)
                                  .then((url) {
                                if (url != null) {
                                  EasyLoading.dismiss();
                                  if (_productImage1 != null) {
                                    _provider.uploadProductImage1(
                                        _productImage1.path,
                                        productName,
                                        productId);
                                  }
                                  if (_productImage2 != null) {
                                    _provider.uploadProductImage2(
                                        _productImage2.path,
                                        productName,
                                        productId);
                                  }
                                  if (_productImage3 != null) {
                                    _provider.uploadProductImage3(
                                        _productImage3.path,
                                        productName,
                                        productId);
                                  }
                                  if (_productImage4 != null) {
                                    _provider.uploadProductImage4(
                                        _productImage4.path,
                                        productName,
                                        productId);
                                  }
                                  if (_productImage5 != null) {
                                    _provider.uploadProductImage5(
                                        _productImage5.path,
                                        productName,
                                        productId);
                                  }
                                  if (_productImage6 != null) {
                                    _provider.uploadProductImage6(
                                        _productImage6.path,
                                        productName,
                                        productId);
                                  }
                                  // _provider.uploadProductImage1(
                                  //     _productImage1.path,
                                  //     productName,
                                  //     productId);
                                  // _provider.uploadProductImage2(
                                  //     _productImage2.path,
                                  //     productName,
                                  //     productId);
                                  // _provider.uploadProductImage3(
                                  //     _productImage3.path,
                                  //     productName,
                                  //     productId);
                                  // _provider.uploadProductImage4(
                                  //     _productImage4.path,
                                  //     productName,
                                  //     productId);
                                  // _provider.uploadProductImage5(
                                  //     _productImage5.path,
                                  //     productName,
                                  //     productId);
                                  // _provider.uploadProductImage6(
                                  //     _productImage6.path,
                                  //     productName,
                                  //     productId);
                                  _provider.saveProductToDb(
                                    context: context,
                                    price: price,
                                    comparedPrice: comparePrice,
                                    brand: _brandTextController.text,
                                    collection: dropdownValue,
                                    productDescription: productDescription,
                                    lowStockQuanity: int.parse(
                                        _lowStockQtyTextController.text),
                                    stockQuantity:
                                        int.parse(_stockQtyTextController.text),
                                    tax: tax,
                                    productName: productName,
                                    productId: productId,
                                  );

                                  setState(() {
                                    _formKey.currentState.reset();
                                    _comparedPriceTextController.clear();
                                    dropdownValue = null;
                                    _subCategoryTextController.clear();
                                    _categoryTextController.clear();
                                    _brandTextController.clear();
                                    _track = false;
                                    _image = null;
                                    _productImage1 = null;
                                    _productImage2 = null;
                                    _productImage3 = null;
                                    _productImage4 = null;
                                    _productImage5 = null;
                                    _productImage6 = null;

                                    _visible = false;
                                    images.clear();
                                  });
                                } else {
                                  _provider.alertDialog(
                                    context: context,
                                    title: 'Product Image Upload',
                                    content: 'Product image upload failed',
                                  );
                                }
                              });
                            } else {
                              _provider.alertDialog(
                                context: context,
                                title: 'Product Image',
                                content: 'Product Image not selected',
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text('Save New Product',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'General',
                  ),
                  Tab(
                    text: 'Inventory',
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter product name';
                                    }
                                    setState(() {
                                      productName = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Product Name',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  maxLength: 500,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter product description';
                                    }
                                    setState(() {
                                      productDescription = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Product Description',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                            child: _image == null
                                                ? Text('Select Image')
                                                : Image.file(_image)),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter product price';
                                    }
                                    setState(() {
                                      price = double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Product Price',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _comparedPriceTextController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        value = (0).toString();
                                      });
                                    }
                                    // if (price > double.parse(value)) {
                                    //   return 'Compared price should be higher than actual price';
                                    // }
                                    setState(() {
                                      comparePrice = double.parse(value);
                                    });

                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Compared price should be higher than your selling price',
                                    labelText: 'Compared Price',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
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
                                TextFormField(
                                  controller: _brandTextController,
                                  decoration: InputDecoration(
                                    labelText: 'Brand',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
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
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
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
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter tax %';
                                    }
                                    setState(() {
                                      tax = double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Tax %',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                // FlatButton(
                                //     color: Theme.of(context).primaryColor,
                                //     onPressed: chooseImages,
                                //     child: Text("Add more product images",
                                //         style: TextStyle(color: Colors.white))),
                                // // images != null ? buildGridView() : Container(),
                                // buildGridView()

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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage1 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage1)),
                                              ),
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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage2 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage2)),
                                              ),
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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage3 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage3)),
                                              ),
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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage4 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage4)),
                                              ),
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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage5 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage5)),
                                              ),
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
                                            child: SizedBox(
                                              width: 250,
                                              height: 250,
                                              child: Card(
                                                child: Center(
                                                    child: _productImage6 ==
                                                            null
                                                        ? Text('Select Image')
                                                        : Image.file(
                                                            _productImage6)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ]),
                        SingleChildScrollView(
                          child: Column(children: [
                            SwitchListTile(
                              title: Text('Track Inventory'),
                              activeColor: Theme.of(context).primaryColor,
                              subtitle: Text(
                                'Switch ON to track Inventory',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              value: _track,
                              onChanged: (selected) {
                                setState(() {
                                  _track = !_track;
                                });
                              },
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _stockQtyTextController,
                                          validator: (value) {
                                            if (_track) {
                                              if (value.isEmpty) {
                                                return 'Enter stock quantity';
                                              }
                                              setState(() {
                                                stockQuantity =
                                                    int.parse(value);
                                              });
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Inventory Quanity',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller:
                                              _lowStockQtyTextController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Inventory low stock quanity',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future uploadProductImages() async {
  //   for (var img in images) {
  //     ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('ProductImages/$productName/${Path.basename(img.path)}');
  //     await ref.putFile(img).whenComplete(() async {
  //       await ref.getDownloadURL().then((value) {
  //         productImages = value;
  //       });
  //     });
  //   }
  // }
}
