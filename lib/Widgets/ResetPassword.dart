import 'package:ahia_vendor/Auth/Login_Screen.dart';
import 'package:ahia_vendor/Providers/AuthProvider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-password';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                Text('Recover your password',
                    style: TextStyle(fontFamily: 'Anton', fontSize: 20)),
              ],
            ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Forgot Password? ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              TextSpan(
                  text:
                      'Don\'t worry, just provide your registered email address, we\'ll help you recovery your account!',
                  style: TextStyle(color: Colors.black87)),
            ])),
            SizedBox(height: 20),
            TextFormField(
                controller: _emailTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
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
                  enabledBorder: OutlineInputBorder(),
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                )),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          _authData.resetPassword(email);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please check your email ${_emailTextController.text} for password reset instructions')));
                        }
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      child: _loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.transparent,
                            )
                          : Text('Reset Password',
                              style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor),
                ),
              ],
            )
          ],
        ),
      )),
    ));
  }
}
