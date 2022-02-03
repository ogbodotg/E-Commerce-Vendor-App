import 'package:ahia_vendor/Auth/Login_Screen.dart';
import 'package:ahia_vendor/Widgets/ImagePicker.dart';
import 'package:ahia_vendor/Widgets/RegistrationForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register-screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
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
                    Text('Register',
                        style: TextStyle(fontFamily: 'Anton', fontSize: 20)),
                  ],
                ),
                ShopPicCard(),
                RegisterForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: RichText(
                        text: TextSpan(text: '', children: [
                          TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ]),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
