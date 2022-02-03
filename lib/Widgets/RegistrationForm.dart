import 'dart:io';

import 'package:ahia_vendor/Pages/HomeScreen.dart';
import 'package:ahia_vendor/Providers/AuthProvider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  // var _addressTextController = TextEditingController();
  // var _descriptionTextController = TextEditingController();
  String email;
  String password;
  String phoneNumber;
  String shopName;
  String description;
  String shopAddress;
  String shopCity;
  String shopState;
  bool _isLoading = false;

  Icon icon;
  bool _visible = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/shopProfilePic/${_nameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}')
        .getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Shop Name';
                    }
                    setState(() {
                      _nameTextController.text = value;
                      shopName = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.add_business),
                    labelText: 'Shop Name',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Phone Number';
                    }
                    setState(() {
                      phoneNumber = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixText: '+234',
                    prefixIcon: Icon(Icons.phone_android),
                    labelText: 'Phone Number',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email Address';
                    }
                    final bool _isValidEmail =
                        EmailValidator.validate(_emailTextController.text);
                    if (!_isValidEmail) {
                      return 'Invalid Email';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email Address',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // obscureText: true,
                  obscureText: _visible == true ? false : true,
                  controller: _passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Password';
                    }
                    if (value.length <= 6) {
                      return 'Password must be more than 6 characters';
                    }
                    setState(() {
                      password = value;
                    });

                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: _visible
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _visible = !_visible;
                        });
                      },
                    ),
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                    labelText: 'Password',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // obscureText: true,
                  obscureText: _visible == true ? false : true,
                  controller: _confirmPasswordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Confirm Password';
                    }

                    if (_passwordTextController.text !=
                        _confirmPasswordTextController.text) {
                      return 'Password doesn\'t match';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: _visible
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _visible = !_visible;
                        });
                      },
                    ),
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                    labelText: 'Confirm Password',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // controller: _addressTextController,
                  maxLines: 2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Add Address Line';
                    }
                    setState(() {
                      shopAddress = value;
                    });
                    // if (_authData.shopLatitude == null) {
                    //   return 'Please use the navigation button to locate your shop';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Shop Address',
                    contentPadding: EdgeInsets.zero,
                    // suffixIcon: IconButton(
                    //     icon: Icon(Icons.location_searching),
                    //     onPressed: () {
                    //       _addressTextController.text =
                    //           'Locating...\n Please hold on';
                    //       _authData.getCurrentAddress().then((address) {
                    //         if (address != null) {
                    //           setState(() {
                    //             _addressTextController.text =
                    //                 '${_authData.placeName}\n${_authData.shopAddress}';
                    //           });
                    //         } else {
                    //           Scaffold.of(context).showSnackBar(SnackBar(
                    //               content: Text('Couldn\'t find shop location')));
                    //         }
                    //       });
                    //     }),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // controller: _addressTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Shop Location City';
                    }
                    setState(() {
                      shopCity = value;
                    });
                    // if (_authData.shopLatitude == null) {
                    //   return 'Please use the navigation button to locate your shop';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Shop Location City',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // controller: _addressTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Shop Location State';
                    }
                    setState(() {
                      shopState = value;
                    });
                    // if (_authData.shopLatitude == null) {
                    //   return 'Please use the navigation button to locate your shop';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city_outlined),
                    labelText: 'Shop Location State',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextFormField(
                  // onChanged: (value) {
                  //   _descriptionTextController.text = value;
                  // },
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Shop description';
                    }
                    setState(() {
                      description = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.comment),
                    labelText: 'Shop description',
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    )),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_authData.isPicked == true) {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _authData
                                .registerVendor(email, password)
                                .then((credential) {
                              if (credential.user.uid != null) {
                                uploadFile(_authData.image.path).then((url) {
                                  if (url != null) {
                                    _authData.saveVendorDatatoDb(
                                      url: url,
                                      shopName: shopName,
                                      phoneNumber: phoneNumber,
                                      shopAddress: shopAddress,
                                      shopCity: shopCity,
                                      shopState: shopState,
                                      description: description,
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.id);
                                  } else {
                                    scaffoldMessage('Shop photo upload failed');
                                  }
                                });
                              }
                            });
                          } else {
                            scaffoldMessage(_authData.error);
                          }
                        } else {
                          scaffoldMessage('Please add shop image/logo');
                          // Scaffold.of(context).showSnackBar(
                          //     SnackBar(content: Text('Please add shop image/logo')));
                        }
                      },
                      child: Text('Register',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ]),
          );
  }
}
