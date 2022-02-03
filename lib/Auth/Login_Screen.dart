import 'package:ahia_vendor/Auth/Register_Screen.dart';
import 'package:ahia_vendor/Pages/HomeScreen.dart';
import 'package:ahia_vendor/Providers/AuthProvider.dart';
import 'package:ahia_vendor/Widgets/ResetPassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
  String password;

  Icon icon;
  bool _visible = false;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    scaffoldMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ahia Vendor',
                              style: TextStyle(
                                  fontFamily: 'Signatra',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Theme.of(context).primaryColor)),
                          SizedBox(height: 20),
                          Text('LOGIN',
                              style:
                                  TextStyle(fontFamily: 'Anton', fontSize: 20)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _emailTextController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final bool _isValidEmail = EmailValidator.validate(
                                _emailTextController.text);
                            if (!_isValidEmail) {
                              return 'Invalid Email';
                            }
                            setState(() {
                              email = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length <= 6) {
                              return 'Password must be more than six characters';
                            }
                            setState(() {
                              password = value;
                            });
                            return null;
                          },
                          obscureText: _visible == true ? false : true,
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
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ResetPassword.id);
                            },
                            child: Text('Forgot Password? ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
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
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  _authData
                                      .loginVendor(email, password)
                                      .then((credential) {
                                    if (credential != null) {
                                      setState(() {
                                        _loading = false;
                                      });
                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.id);
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      scaffoldMessage(_authData.error);
                                    }
                                  });
                                }
                              },
                              child: _loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : Text('Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            child: RichText(
                              text: TextSpan(text: '', children: [
                                TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ]),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: FlatButton(
                      //         color: Theme.of(context).primaryColor,
                      //         onPressed: () {
                      //           Navigator.pushNamed(context, RegisterScreen.id);
                      //         },
                      //         child: Text('Register',
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold)),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
